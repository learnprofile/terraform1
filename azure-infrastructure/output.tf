output "infra_external_lb_public_ip" {
  value = "${azurerm_public_ip.infra_external_lb_public_ip.ip_address}"
}

output "master_external_lb_public_ip" {
  value = "${azurerm_public_ip.master_external_lb_public_ip.ip_address}"
}

output "deployment_instance_ip" {
  value = "${azurerm_network_interface.deployment-instance[0].private_ip_address}"
}

output "registry_primary_access_key" {
  value = "${azurerm_storage_account.openshiftclusterregistry.primary_access_key}"
}

output "registry_name" {
  value = "${azurerm_storage_account.openshiftclusterregistry.name}"
}