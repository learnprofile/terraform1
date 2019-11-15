variable "resource_group" {}


resource "azurerm_storage_account" "storage"{
    name                     = "staticoutputstorage"
    resource_group_name      = "${var.resource_group}"
    location                 = "westus2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_container" {
    name = "devweelimafunc"
    storage_account_name = "${azurerm_storage_account.storage.name}"
    container_access_type = "container"
}

output "stac_primary_cnn_string" {
  value = "${azurerm_storage_account.storage.primary_connection_string}"
}
