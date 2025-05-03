resource "azurerm_linux_virtual_machine_scale_set" "app" {
  name                = "vmss-app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  upgrade_mode        = "Manual"
  instances           = var.vmss_instance_count
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_password

  sku {
    name     = "Standard_B2s"
    tier     = "Standard"
    capacity = var.vmss_instance_count
  }

  source_image_id = var.source_image_id

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


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "vmss-nic"
    primary = true

    ip_configuration {
      name      = "vmss-ipconfig"
      subnet_id = azurerm_subnet.vmss_subnet.id
      primary   = true
    }
  }

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  depends_on = [azurerm_network_interface_security_group_association.vmss_nic_nsg]
}
