resource "azurerm_network_interface" "worker" {
  count                     = "${var.worker_instances_count}"
  name                      = "worker-${count.index}-network-interface"
  location                  = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name       = "${data.azurerm_resource_group.openshift.name}"
  network_security_group_id = "${data.azurerm_network_security_group.worker.id}"

  ip_configuration {
    name                          = "worker-${count.index}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${data.azurerm_subnet.worker.id}"
    //    private_ip_address            = "${cidrhost(azurerm_subnet.node-subnet.address_prefix, count.index + 10)}"
  }

  tags                      = "${var.tags}"
}

resource "azurerm_virtual_machine" "worker-instance" {
  count                            = "${var.worker_instances_count}"
  name                             = "worker-${count.index}"
  location                         = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name              = "${data.azurerm_resource_group.openshift.name}"


  lifecycle {
    ignore_changes = [
      "storage_data_disk"]
  }

  vm_size                          = "${var.worker_node_shape}"
  availability_set_id              = "${data.azurerm_availability_set.worker.id}"
  network_interface_ids            = [
    "${element(azurerm_network_interface.worker.*.id, count.index)}"]

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.4"
    version   = "latest"
  }
  os_profile {
    computer_name  = "worker-${count.index}"
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
    name              = "worker-${count.index}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_data_disk {
    name              = "worker-${count.index}-datadisk"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "32"
  }

  tags                             = "${merge(var.tags, map("Name", "${var.platform_name}-infra"), map("cluster_role", "worker"))}"
}