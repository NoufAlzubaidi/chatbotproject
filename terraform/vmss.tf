loacls { 
source_image_id =  "/subscriptions/9896598a-01c4-4709-b370-042f72f0e1ce/resourcegroups/milestone-sda/providers/Microsoft.Compute/galleries/myimage/images/chatbot-image/versions/1.0.0"
}


resource "azurerm_linux_virtual_machine_scale_set" "web_vmss" {
  name                = "${local.resource_name_prefix}-web-vmss-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_D2s_v6"
  instances           = 2
  admin_username      = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

 # source_image_reference {
  #  publisher = "canonical"
   # offer     = "ubuntu-24_04-lts"
   # sku       = "server"
    #version   = "latest"
 # }

source_image_id = local.source_image_id

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  upgrade_mode = "Automatic"
  secure_boot_enabled = true 
  
  identity {
   type = "SystemAssigned"
  }

  network_interface {
    name    = "web-vmss-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      ip_configuration {
        name = "internal"
        primary = true
        subnet_id = azurerm_subnet.websubnet.id
        application_gateway_backend_address_pool_ids = [tolist(azurerm_application_gateway.web_ag.backend_address_pool)[0].id]
          }
      }  
  }

output "web_vmss_id" {
  description = "Web Virtual Machine Scale Set ID "
  value = azurerm_linux_virtual_machine_scale_set.web_vmss.id
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name = "myautoscaleSetting"
  resource_group_name = azurerm_resource_group.rg.name
   location            = azurerm_resource_group.rg.location
  target_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id

}

profile {
  name ="defaultprofile"
  capacity {
    default = 2
    minimum = 2 
    maximum = 3
  }

#scale-out 1 instance if the cpu is greater than 75%
rule {
  metric_trigger {
    metric_name = "percentage CPU"
     metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
    time_grain = "PT1M" # 1min 
    statistic = "Average"
    time_window = "PT5M" # 5min
    time_aggregation = "Average"
    operator = 80 
    metric_namespace = "microsoft.compute/virtualmachinescalesets"

    }

scale_action {
  direction = "Increase"
  type = "ChangeCount"
  value = "1"
  cooldown = "PT1M"
  }
}

#scale-out 1 instance if the cpu is less than 25%
rule {
  metric_trigger {
    metric_name = "percentage CPU"
    metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
    time_grain = "PT1M" # 1min 
    statistic = "Average"
    time_window = "PT5M" # 5min
    time_aggregation = "Average"
    operator = LessThan
    threshold = 20 
   }
    scale_action {
      direction = "Decrease"
      type = "ChangeCount"
      value = "1"
      cooldown = "PT1M"
      }
    }
  }  
}
 

