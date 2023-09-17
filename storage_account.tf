resource "random_string" "storage_account" {
  length  = 6
  special = false
  upper   = false
}

# Storage account for functionapp
resource "azurerm_storage_account" "fn-storageaccount" {
  name                     = "${var.fn_stg_acc_name}${random_string.storage_account.result}"
  resource_group_name      = azurerm_resource_group.rg-1.name
  location                 = azurerm_resource_group.rg-1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Dev"
  }
}


resource "azurerm_storage_account" "demo-storage" {
  name                     = "${var.stg_acc_name}${random_string.storage_account.result}"
  resource_group_name      = azurerm_resource_group.rg-1.name
  location                 = azurerm_resource_group.rg-1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "Test"
  }
}