
provider "azurerm" {
subscription_id = "f3db9121-0ace-436c-88a3-3e91be033ce4"
tenant_id = "354d552b-0857-4910-bd2c-f935eddb9a03"
client_id = "b0fa3584-8390-4974-98d5-089d6c97732f"
client_secret = "1QACux5O?6l6q[ob]KLXTFF]I14_LXDP"
}

resource "azurerm_resource_group" "devweek_rg" {
  name     = "maersktestgroup"
  location = "westus2"
  tags = {
    createdBy="Terraform"
  }
}

module "stac_website"{
  source = "./stac-website"
  resource_group = "${azurerm_resource_group.devweek_rg.name}"
}

module "az_function" {
  source = "./az-functions"
  resource_group = "${azurerm_resource_group.devweek_rg.name}"
  stac_primary_cnn_string = "${module.stac_website.stac_primary_cnn_string}"
}



