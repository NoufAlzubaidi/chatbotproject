provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "terraform-sda"
  location = "Norway East"
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-tfapp"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
