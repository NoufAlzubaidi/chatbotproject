resource "azurerm_linux_virtual_machine_scale_set" "web_vmss" {
  name                = "${local.resource_name_prefix}-vmss-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_B2ms"
  instances           = 2
  admin_username      = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "vmss-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.websubnet.id
    }
  }

  custom_data = base64encode(file("${path.module}/init_script.sh"))

  lifecycle {
    ignore_changes = [instances]
  }
}
