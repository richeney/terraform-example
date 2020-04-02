terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"  
    storage_account_name = "npsclientap95y6n6936"
    container_name       = "tfstate-2ca40be1-7e80-4f2b-92f7-06b2123a68cc-hub"
    key                  = "terraform.tfstate"
  }
}
