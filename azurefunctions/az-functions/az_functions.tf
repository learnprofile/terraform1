variable "resource_group" {}
variable "stac_primary_cnn_string" {}

resource "azurerm_app_service_plan" "sp" {
  name                = "az-functions-sp"
  location            = "westus2"
  resource_group_name = "${var.resource_group}"
  
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "function" {
  name                      = "maersk-function"
  location                  = "${azurerm_app_service_plan.sp.location}"
  resource_group_name       = "${var.resource_group}"
  app_service_plan_id       = "${azurerm_app_service_plan.sp.id}"
  storage_connection_string = "${var.stac_primary_cnn_string}"
}