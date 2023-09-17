resource "azurerm_service_plan" "fe-asp" {
  name                = var.fe_asp_name
  resource_group_name = azurerm_resource_group.rg-1.name
  location            = azurerm_resource_group.rg-1.location
  os_type             = "Linux"
  sku_name            = "B1"
  depends_on = [
    data.azurerm_subnet.fe-subnet
  ]
}

resource "azurerm_service_plan" "be-asp" {
  name                = var.be_asp_name
  resource_group_name = azurerm_resource_group.rg-1.name
  location            = azurerm_resource_group.rg-1.location
  os_type             = "Linux"
  sku_name            = "B1"
  depends_on = [
    data.azurerm_subnet.be-subnet
  ]
}
