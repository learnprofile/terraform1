output "master_dns_name" {
  value = "${azurerm_dns_a_record.dns_master_name.name}"
}