resource "azurerm_subnet" "db_subnet" {
  name                 = "subnet-db"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
}

resource "azurerm_subnet" "vmss_subnet" {
  name                 = "subnet-vmss"
  address_prefixes     = ["10.0.2.0/24"]
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
}

resource "azurerm_subnet" "appgw_subnet" {
  name                 = "subnet-appgw"
  address_prefixes     = ["10.0.3.0/24"]
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
}

resource "azurerm_network_security_group" "vmss_nsg" {
  name                = "nsg-vmss"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
