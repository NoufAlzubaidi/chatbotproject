resource "azurerm_public_ip" "web_vm_publicip" {
  name                = "${var.resource_prefix}-${var.environment}-web-vm-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.resource_prefix}-${var.environment}-vm-${random_string.myrandom.id}"  # تعديل هنا لضمان التفرد
}

resource "azurerm_network_interface" "web_vm_nic" {
  name                = "${var.resource_prefix}-${var.environment}-web-vm-nic-${random_string.myrandom.id}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.websubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_vm_publicip.id
  }
}

resource "azurerm_linux_virtual_machine" "web_vm" {
  name                = "${var.resource_prefix}-${var.environment}-web-vm-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2ms"
  admin_username      = "azureuser"  

  network_interface_ids = [azurerm_network_interface.web_vm_nic.id]
  
  custom_data = filebase64("${path.module}/init_script.sh")
  
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}
