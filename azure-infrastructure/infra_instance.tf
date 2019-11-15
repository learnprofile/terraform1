resource "azurerm_network_interface" "infra" {
  count                     = "${var.infra_instances_count}"
  name                      = "infra-${count.index}-network-interface"
  location                  = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name       = "${data.azurerm_resource_group.openshift.name}"
  network_security_group_id = "${data.azurerm_network_security_group.infra.id}"

  ip_configuration {
    name                          = "infra-${count.index}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${data.azurerm_subnet.infra.id}"
    //    private_ip_address            = "${cidrhost(azurerm_subnet.infra-subnet.address_prefix, count.index + 10)}"
  }

  tags                      = "${var.tags}"
}

resource "azurerm_network_interface_backend_address_pool_association" "infra" {
  count                   = "${var.infra_instances_count}"
  network_interface_id    = "${element(azurerm_network_interface.infra.*.id, count.index)}"
  ip_configuration_name   = "infra-${count.index}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.infra_external_lb_backend_pool.id}"
}

resource "azurerm_virtual_machine" "infra-instance" {
  count                            = "${var.infra_instances_count}"
  name                             = "infra-${count.index}"
  location                         = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name              = "${data.azurerm_resource_group.openshift.name}"

  vm_size                          = "${var.infra_node_shape}"
  availability_set_id              = "${data.azurerm_availability_set.infra.id}"
  network_interface_ids            = [
    "${element(azurerm_network_interface.infra.*.id, count.index)}"]

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.4"
    version   = "latest"
  }
  os_profile {
    computer_name  = "infra-${count.index}"
    admin_username = "${var.admin_username}"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = "${file(var.public_key_path)}"
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      # that the only allowed path due to a limitation of Azure
    }
  }
  storage_os_disk {
    name              = "infra-${count.index}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_data_disk {
    name              = "infra-${count.index}-datadisk"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "32"
  }

  tags                             = "${merge(var.tags, map("Name", "${var.platform_name}-infra"), map("cluster_role", "router"))}"
}
