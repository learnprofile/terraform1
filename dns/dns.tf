# Add DNS Records for the 3 Public Load balancer endpoints.
resource "azurerm_dns_a_record" "dns_master_name" {
  name                = "master.${var.platform_name}"
  zone_name           = "${data.azurerm_dns_zone.openshift.name}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
  ttl                 = 60
  records             = [
    "${var.master_external_lb_ip_address}"]
}

resource "azurerm_dns_a_record" "dns_wildcard" {
  name                = "*.${var.platform_name}"
  zone_name           = "${data.azurerm_dns_zone.openshift.name}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
  ttl                 = 60
  records             = [
    "${var.router_external_lb_ip_address}"]
}

resource "azurerm_dns_a_record" "dns_bastion_name" {
  name                = "bastion.${var.platform_name}"
  zone_name           = "${data.azurerm_dns_zone.openshift.name}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
  ttl                 = 60
  records             = [
    "${var.bastion_ip_address}"]
}
