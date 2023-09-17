resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = var.loganalytics_name
  resource_group_name = azurerm_resource_group.rg-1.name
  location            = azurerm_resource_group.rg-1.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "appinsights" {
  name                = var.appinsights_name
  location            = azurerm_resource_group.rg-1.location
  resource_group_name = azurerm_resource_group.rg-1.name
  workspace_id        = azurerm_log_analytics_workspace.loganalytics.id
  application_type    = "web"
  depends_on = [
    azurerm_log_analytics_workspace.loganalytics
  ]
}

output "instrumentation_key" {
  value     = azurerm_application_insights.appinsights.instrumentation_key
  sensitive = true
}

output "app_id" {
  value     = azurerm_application_insights.appinsights.id
  sensitive = true
}