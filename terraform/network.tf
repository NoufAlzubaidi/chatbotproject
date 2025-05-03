resource "azurerm_subnet" "subnet_vmss" {
  name                 = "subnet-vmss"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "vmss_nsg" {
  name                = "vmss-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "vmss_nic_nsg" {
  subnet_id                 = azurerm_subnet.subnet_vmss.id
  network_security_group_id = azurerm_network_security_group.vmss_nsg.id
}

resource "azurerm_linux_virtual_machine_scale_set" "app" {
  name                = "app-vmss"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard_B2s"
  instances           = 2
  admin_username      = var.vm_admin_username
  source_image_id     = var.source_image_id

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "vmss-nic"
    primary = true
    ip_configuration {
      name      = "internal"
      subnet_id = azurerm_subnet.subnet_vmss.id
      primary   = true
    }
  }

  depends_on = [azurerm_subnet_network_security_group_association.vmss_nic_nsg]
}

resource "azurerm_image" "custom" {
  name                = "myCustomImage"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  os_disk {
    os_type       = "Linux"
    os_state      = "Generalized"
    caching       = "ReadWrite"
    storage_type  = "Standard_LRS"
    managed_disk_id = var.managed_disk_id
  }
}
