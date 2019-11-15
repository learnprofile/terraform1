resource "azurerm_network_security_group" "deployment-instance-nsg" {
  count               = "${var.deployment_instance_enabled ? 1 : 0 }"
  name                = "deployment-instance-nsg"
  location            = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"

  tags                = "${var.tags}"

  security_rule {
    name                       = "ssh"
    priority                   = "500"
    access                     = "Allow"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    destination_port_ranges    = [
      "22"]
    source_port_range          = "*"
    destination_address_prefix = "*"
    description                = "SSH from the bastion"
  }
}

resource "azurerm_network_interface" "deployment-instance" {
  count                     = "${var.deployment_instance_enabled ? 1 : 0 }"
  name                      = "deployment-instance-network-interface"
  location                  = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name       = "${data.azurerm_resource_group.openshift.name}"
  network_security_group_id = "${azurerm_network_security_group.deployment-instance-nsg[count.index].id}"

  ip_configuration {
    name                          = "deployment-instance-subnet"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${data.azurerm_subnet.worker.id}"
  }
}

resource "azurerm_virtual_machine" "deployment-instance" {
  count                         = "${var.deployment_instance_enabled ? 1 : 0 }"
  name                          = "deployment-instance"
  location                      = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name           = "${data.azurerm_resource_group.openshift.name}"

  vm_size                       = "${var.deployment_instance_shape}"
  network_interface_ids         = [
    "${azurerm_network_interface.deployment-instance[count.index].id}"]
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7-CI"
    version   = "latest"
  }

  os_profile {
    computer_name  = "deployment-instance"
    admin_username = "${var.admin_username}"
    custom_data    = "${data.template_cloudinit_config.deployment_instance_config.rendered}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = "${file(var.public_key_path)}"
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }

  storage_os_disk {
    name              = "deployment-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  tags                          = "${merge(var.tags, map("Name", "${var.platform_name}-deployment-instance"))}"
}

data "template_file" "deployment_instance_init" {
  template = "${file("${path.module}/resources/deployment-instance-init.yaml")}"

  vars     = {
    openshift_major_version = "${var.openshift_major_version}"
  }
}

data "template_cloudinit_config" "deployment_instance_config" {
  gzip          = true
  base64_encode = true

  part {
    content = "${data.template_file.deployment_instance_init.rendered}"
  }
}
