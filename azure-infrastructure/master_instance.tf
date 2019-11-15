resource "azurerm_network_interface" "master" {
  count                     = "${var.master_instances_count}"
  name                      = "master-${count.index}-network-interface"
  location                  = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name       = "${data.azurerm_resource_group.openshift.name}"
  network_security_group_id = "${data.azurerm_network_security_group.master.id}"

  ip_configuration {
    name                          = "master-${count.index}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${data.azurerm_subnet.master.id}"
    //    private_ip_address            = "${cidrhost(azurerm_subnet.master-subnet.address_prefix, count.index + 10)}"
  }

  tags                      = "${var.tags}"
}

resource "azurerm_network_interface_backend_address_pool_association" "master" {
  count                   = "${var.master_instances_count}"
  network_interface_id    = "${element(azurerm_network_interface.master.*.id, count.index)}"
  ip_configuration_name   = "master-${count.index}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.master_external_lb_backend_pool.id}"
}

resource "azurerm_virtual_machine" "master-instance" {
  count                            = "${var.master_instances_count}"
  name                             = "master-${count.index}"
  location                         = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name              = "${data.azurerm_resource_group.openshift.name}"

  vm_size                          = "${var.master_node_shape}"
  availability_set_id              = "${data.azurerm_availability_set.master.id}"
  network_interface_ids            = [
    "${element(azurerm_network_interface.master.*.id, count.index)}"]

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.4"
    version   = "latest"
  }
  os_profile {
    computer_name  = "master-${count.index}"
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
    name              = "master-${count.index}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_data_disk {
    name              = "master-${count.index}-datadisk"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "32"
  }

  tags                             = "${merge(var.tags, map("Name", "${var.platform_name}-master"), map("cluster_role", "master"))}"
}
