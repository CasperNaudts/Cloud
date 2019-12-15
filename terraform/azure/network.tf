resource "azurerm_virtual_network" "main" {
  name                = "production-network"
  resource_group_name = azurerm_resource_group.cloud.name
  location            = azurerm_resource_group.cloud.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.cloud.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.2.0/24"
}