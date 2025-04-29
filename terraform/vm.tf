resource "azurerm_virtual_machine" "tf-vm" {
  name                         = "tf-vm"
  location                     = azurerm_resource_group.main.location
  resource_group_name          = azurerm_resource_group.main.name
  size                         = "Standard_B2ms" 
  admin_username               = "azureuser"
  admin_password               = var.vm_admin_password
  network_interface_ids        = [azurerm_network_interface.tf-vm_nic.id]
  storage_os_disk {
    name              = "tv-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed           = true
    os_type           = "Linux" 
  }

  os_profile {
    computer_name  = "tf-vm"
    admin_username = "azureuser"
    admin_password = var.vm_admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "production"
  }
}

resource "azurerm_network_interface" "tf-vm_nic" {
  name                = "tf-vm-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf-vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
