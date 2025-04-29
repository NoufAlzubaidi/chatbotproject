resource "azurerm_linux_virtual_machine_scale_set" "app" {
  name                = "vmss-app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  upgrade_mode        = "Manual"
  instances           = 2
  admin_username      = "azureuser"
  admin_password      = var.vm_password

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20_04-lts"
    version   = "latest"
  }

  sku {
    name     = "Standard_B2s"
    tier     = "Standard"
    capacity = 2
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "vmss-nic"
    primary = true

    ip_configuration {
      name      = "vmss-ipconfig"
      subnet_id = azurerm_subnet.app_subnet.id
      primary   = true
    }
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  depends_on = [azurerm_network_interface_security_group_association.vmss_nic_nsg]
}
