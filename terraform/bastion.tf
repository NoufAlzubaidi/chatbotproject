resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  address_prefixes     = ["10.0.4.0/24"]
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
}

resource "azurerm_bastion_host" "terraform" {
  name                = "terraform-bastion"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_name            = "terraform-bastion"
  virtual_network_id  = azurerm_virtual_network.main.id
  subnet_id           = azurerm_subnet.bastion_subnet.id

  tags = {
    environment = "production"
  }
}
