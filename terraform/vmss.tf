locals {
  source_image_id = "/subscriptions/9896598a-01c4-4709-b370-042f72f0e1ce/resourcegroups/milestone-sda/providers/Microsoft.Compute/galleries/myimage/images/chatbot-image/versions/1.0.0"
}

resource "azurerm_linux_virtual_machine_scale_set" "web_vmss" {
  name                = "${var.resource_prefix}-${var.environment}-web-vmss-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_B1s"
  instances           = 1
  admin_username      = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

  source_image_id = local.source_image_id

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  upgrade_mode        = "Automatic"
  secure_boot_enabled = true
  
  identity {
    type = "SystemAssigned"
  }

  network_interface {
    name    = "web-vmss-nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.websubnet.id
      application_gateway_backend_address_pool_ids = [tolist(azurerm_application_gateway.web_ag.backend_address_pool)[0].id]
    }
  }
}

# الموارد التالية يجب أن تكون خارج كتلة VMSS
resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "${var.resource_prefix}-${var.environment}-autoscale"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.web_vmss.id

  profile {
    name = "defaultprofile"
    
    capacity {
      default = 2
      minimum = 2 
      maximum = 3
    }

    # scale-out 1 instance if CPU > 75%
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    # scale-in 1 instance if CPU < 25%
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}

output "web_vmss_id" {
  description = "Web Virtual Machine Scale Set ID"
  value       = azurerm_linux_virtual_machine_scale_set.web_vmss.id
}
