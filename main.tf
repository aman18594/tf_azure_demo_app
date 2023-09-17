resource "azurerm_resource_group" "rg-1" {
  name     = "tf-project-rg-dev"
  location = var.location-rg
}

