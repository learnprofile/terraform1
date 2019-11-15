terraform {
   backend "azurerm" { 
      storage_account_name = "maerskinternetstg"
      container_name       = "terraform"
      key                  = "terraform.tfstate"
      environment          = ""
      access_key           = "d9gIHg2+uh//N1ee4Pwhm8ZwnNvKG4XQ8r3UqJSfZypF3jRdnUpLHFOxoH3QpRe2Xaco2ciz9QB6XYr3/jb08Q=="
   }
} 
