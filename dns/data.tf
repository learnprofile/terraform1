data "azurerm_resource_group" "openshift" {
  name     = "${var.resource_group_name}"
}

data "azurerm_dns_zone" "openshift" {
  name                = "${var.dns_domain_name}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
}