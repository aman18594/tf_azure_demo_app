# data "azurerm_key_vault" "my-keyvault" {}
# data "azurerm_subnet" "be-subnet" {}

# resource "azurerm_resource_group" "rg-azuresql-module3" {
#   name     = "${var.azuresql_rg_name}-RG"
#   location = var.azuresql_location_name
# }

# # Create Random password 
# resource "random_password" "randompassword" {
#   length           = 16
#   special          = true
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }

# # Create Key Vault Secret
# resource "azurerm_key_vault_secret" "sqladminpassword" {
#   # checkov:skip=CKV_AZURE_41:Expiration not needed 
#   name         = "sqladmin"
#   value        = random_password.randompassword.result
#   key_vault_id = data.azurerm_key_vault.my-keyvault.id
#   content_type = "text/plain"
#   depends_on = [
#     azurerm_key_vault.my-keyvault,azurerm_key_vault_access_policy.kv_access_policy_01,azurerm_key_vault_access_policy.kv_access_policy_02,azurerm_key_vault_access_policy.kv_access_policy_03
#   ]
# }

# # Azure sql database
# resource "azurerm_mssql_server" "azuresql" {
#   name                         = var.azuresql_name
#   resource_group_name          = azurerm_resource_group.rg-azuresql-module3.name
#   location                     = azurerm_resource_group.rg-azuresql-module3.location
#   version                      = "12.0"
#   administrator_login          = "4adminu$er"
#   administrator_login_password = random_password.randompassword.result

#   azuread_administrator {
#     login_username = "AzureAD Admin"
#     object_id      = ""
#   }
# }

# # Add subnet from the backend vnet

# resource "azurerm_mssql_virtual_network_rule" "allow-be" {
#   name      = var.azuresql_vnet_rule
#   server_id = azurerm_mssql_server.azuresql.id
#   subnet_id = data.azurerm_subnet.be-subnet.id
#   depends_on = [
#     azurerm_mssql_server.azuresql
#   ]
# }

# resource "azurerm_mssql_database" "my-database" {
#   name           = azurerm_mssql_server.azuresql.name
#   server_id      = azurerm_mssql_server.azuresql.id 
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   max_size_gb    = 2
#   read_scale     = false
#   sku_name       = "S0"
#   zone_redundant = false

#   tags = {
#     Application = "TF-Project-Demo"
#     Env = "Dev"
#   }
# }

# resource "azurerm_key_vault_secret" "sqldb_cnxn" {
#   name = var.my_sqldbconn_name
#   value = "Driver={ODBC Driver 18 for SQL Server};Server=tcp:my-sqldb-dev.database.windows.net,1433;Database=fg-db;Uid=4adminu$er;Pwd=${random_password.randompassword.result};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
#   key_vault_id = data.azurerm_key_vault.my-keyvault.id
#   depends_on = [
#     azurerm_mssql_database.my-database,azurerm_key_vault_access_policy.kv_access_policy_01,azurerm_key_vault_access_policy.kv_access_policy_02,azurerm_key_vault_access_policy.kv_access_policy_03
#   ]
# }