data "azurerm_resource_group" "openshift" {
  name     = "${var.resource_group_name}"
}

data "azurerm_subnet" "master" {
  name     = "${var.master_subnet_name}"
  virtual_network_name = "${var.openshift_virtual_network_name}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
}

data "azurerm_network_security_group" "master" {
  name     = "${var.master_nsg_name}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
}

data "azurerm_availability_set" "master" {
  name     = "${var.master_availability_set_name}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
}

data "azurerm_subnet" "infra" {
  name     = "${var.infra_subnet_name}"
  virtual_network_name = "${var.openshift_virtual_network_name}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
}

data "azurerm_network_security_group" "infra" {
  name     = "${var.infra_nsg_name}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
}

data "azurerm_availability_set" "infra" {
  name     = "${var.infra_availability_set_name}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
}

data "azurerm_subnet" "worker" {
  name     = "${var.worker_subnet_name}"
  virtual_network_name = "${var.openshift_virtual_network_name}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
}

data "azurerm_network_security_group" "worker" {
  name     = "${var.worker_nsg_name}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
}

data "azurerm_availability_set" "worker" {
  name     = "${var.worker_availability_set_name}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
}