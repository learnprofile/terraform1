resource "azurerm_storage_account" "openshiftclusterregistry" {
  name                      = "${replace(var.platform_name, "/\\W/", "")}openshiftregistry"
  location                  = "${data.azurerm_resource_group.openshift.location}"
  resource_group_name       = "${data.azurerm_resource_group.openshift.name}"
  account_kind              = "BlobStorage"
  account_tier              = "Standard"
  account_replication_type  = "LRS"

  tags                             = "${var.tags}"
}