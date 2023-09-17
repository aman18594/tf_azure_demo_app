terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-blobstore"
    storage_account_name = "tfbackendstgname"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}