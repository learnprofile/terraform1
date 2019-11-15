resource "azurerm_public_ip" "infra_external_lb_public_ip" {
  name                = "infraExternalLBPublicIP"
  location            = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
  allocation_method   = "Static"
  domain_name_label   = "${var.platform_name}-infra"
}

#Create master LB to be used by the master instances
resource "azurerm_lb" "infra_external_lb" {
  name                = "infraExternalLB"
  location            = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"

  frontend_ip_configuration {
    name                 = "infraExternalLB"
    public_ip_address_id = "${azurerm_public_ip.infra_external_lb_public_ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "infra_external_lb_backend_pool" {
  name                = "masterExternalLBBackendPool"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
  loadbalancer_id     = "${azurerm_lb.infra_external_lb.id}"
}

resource "azurerm_lb_probe" "infra_external_lb_health_probe" {
  name                = "infraExternalLBHealthProbe"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
  protocol            = "Tcp"
  port                = "80"
  loadbalancer_id     = "${azurerm_lb.infra_external_lb.id}"
}

resource "azurerm_lb_rule" "infra_external_lb_http_rule" {
  name                           = "infraExternalLBHttpRule"
  resource_group_name            = "${data.azurerm_resource_group.openshift.name}"
  protocol                       = "Tcp"
  frontend_port                  = "80"
  backend_port                   = "80"
  probe_id                       = "${azurerm_lb_probe.infra_external_lb_health_probe.id}"
  load_distribution              = "SourceIPProtocol"
  frontend_ip_configuration_name = "infraExternalLB"
  idle_timeout_in_minutes        = 30
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.infra_external_lb_backend_pool.id}"
  loadbalancer_id                = "${azurerm_lb.infra_external_lb.id}"
}

resource "azurerm_lb_rule" "infra_external_lb_https_rule" {
  name                           = "infraExternalLBHttpsRule"
  resource_group_name            = "${data.azurerm_resource_group.openshift.name}"
  protocol                       = "Tcp"
  frontend_port                  = "443"
  backend_port                   = "443"
  probe_id                       = "${azurerm_lb_probe.infra_external_lb_health_probe.id}"
  load_distribution              = "SourceIPProtocol"
  frontend_ip_configuration_name = "infraExternalLB"
  idle_timeout_in_minutes        = 30
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.infra_external_lb_backend_pool.id}"
  loadbalancer_id                = "${azurerm_lb.infra_external_lb.id}"
}