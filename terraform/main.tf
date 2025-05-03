
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-tfapp"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_image" "custom" {
  name                = "myCustomImage"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = "chatbotvm_OsDisk_1_5f0d1a1d613a47a684ead74a65687684" 
    caching  = "ReadWrite"
  }
}
