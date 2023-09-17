# Frontend
# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "fe-webapp" {
  name                = var.fe_webapp_name
  resource_group_name = azurerm_resource_group.rg-1.name
  location            = azurerm_resource_group.rg-1.location
  service_plan_id     = azurerm_service_plan.fe-asp.id
  https_only          = true
  site_config {
    minimum_tls_version = "1.2"
    always_on           = true

    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {

    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.appinsights.instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION"        = "1.0.0"
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"
  }


  depends_on = [
    azurerm_service_plan.fe-asp, azurerm_application_insights.appinsights
  ]
}

# Define the data source to get information about the existing subnet
# data "azurerm_subnet" "fe-subnet" {
#   name                 = "fe-subnet"
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   resource_group_name  = azurerm_resource_group.rg-1.name
# }

# data "azurerm_subnet" "be-subnet" {
#   name                 = "be-subnet"
#   resource_group_name  = azurerm_resource_group.rg-1.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
# }

# Backend
resource "azurerm_linux_function_app" "be-fnapp" {
  name                = var.be_fnapp_name
  resource_group_name = azurerm_resource_group.rg-1.name
  location            = azurerm_resource_group.rg-1.location

  storage_account_name       = azurerm_storage_account.fn-storageaccount.name
  storage_account_access_key = azurerm_storage_account.fn-storageaccount.primary_access_key
  service_plan_id            = azurerm_service_plan.be-asp.id


  app_settings = {

    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.appinsights.instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION"        = "1.0.0"
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"


  }

  site_config {

    ip_restriction {
      virtual_network_subnet_id = azurerm_subnet.fe-subnet.id
      priority                  = 100
      name                      = "Frontend access only"
    }
    application_stack {
      python_version = 3.8
    }
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_storage_account.fn-storageaccount
  ]
}

# vnet integration of backend functions
resource "azurerm_app_service_virtual_network_swift_connection" "be-vnet-integration" {
  app_service_id = azurerm_linux_function_app.be-fnapp.id
  subnet_id      = azurerm_subnet.be-subnet.id
  depends_on = [
    azurerm_linux_function_app.be-fnapp
  ]
}

# vnet integration of frontend functions
resource "azurerm_app_service_virtual_network_swift_connection" "fe-vnet-integration" {
  app_service_id = azurerm_linux_web_app.fe-webapp.id
  subnet_id      = azurerm_subnet.fe-subnet.id

  depends_on = [
    azurerm_linux_web_app.fe-webapp
  ]
}