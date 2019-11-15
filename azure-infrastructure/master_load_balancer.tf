#Allocate static public IP address for master LB
resource "azurerm_public_ip" "master_external_lb_public_ip" {
  name                = "masterExternalLBPublicIP"
  location            = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
  allocation_method   = "Static"
  domain_name_label   = "${var.platform_name}-master"

  tags = "${var.tags}"
}

#Create master LB to be used by the master instances
resource "azurerm_lb" "master_external_lb" {
  name                = "masterExternalLB"
  location            = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"

  frontend_ip_configuration {
    name                 = "masterExternalLB"
    public_ip_address_id = "${azurerm_public_ip.master_external_lb_public_ip.id}"
  }

  tags = "${var.tags}"
}

resource "azurerm_lb_backend_address_pool" "master_external_lb_backend_pool" {
  name                = "masterExternalLBBackendPool"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
  loadbalancer_id     = "${azurerm_lb.master_external_lb.id}"
}

#Create probes to validate that master instances in the backend pools are available
resource "azurerm_lb_probe" "master_external_lb_health_probe" {
  name                = "masterExternalLBHealthProbe"
  resource_group_name = "${data.azurerm_resource_group.openshift.name}"
  protocol            = "Tcp"
  port                = "443"
  loadbalancer_id     = "${azurerm_lb.master_external_lb.id}"
}

resource "azurerm_lb_rule" "master_external_lb_rule" {
  name                           = "masterExternalLBHealthRule"
  resource_group_name            = "${data.azurerm_resource_group.openshift.name}"
  protocol                       = "Tcp"
  frontend_port                  = "443"
  backend_port                   = "443"
  probe_id                       = "${azurerm_lb_probe.master_external_lb_health_probe.id}"
  load_distribution              = "SourceIPProtocol"
  frontend_ip_configuration_name = "masterExternalLB"
  idle_timeout_in_minutes        = 30
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.master_external_lb_backend_pool.id}"

  loadbalancer_id                = "${azurerm_lb.master_external_lb.id}"
}