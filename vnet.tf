# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "tf-project-vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-1.location
  resource_group_name = azurerm_resource_group.rg-1.name
}


# Get output variables
output "resource_group_id" {
  value = azurerm_resource_group.rg-1.id
}

# Create subnets
resource "azurerm_subnet" "fe-subnet" {
  name                 = "fe-subnet"
  resource_group_name  = azurerm_resource_group.rg-1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/26"]
  service_endpoints    = ["Microsoft.Web"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action", "Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }

  }

  lifecycle {
    ignore_changes = [
      delegation,
    ]
  }
}

# Create subnets
resource "azurerm_subnet" "be-subnet" {
  name                 = "be-subnet"
  resource_group_name  = azurerm_resource_group.rg-1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.64/26"]
  service_endpoints    = ["Microsoft.Sql"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action", "Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }

  }

  lifecycle {
    ignore_changes = [
      delegation,
    ]
  }
}