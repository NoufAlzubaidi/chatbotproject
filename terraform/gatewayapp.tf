resource "azurerm_public_ip" "web_ag_publicip" {
  name                = "${var.resource_prefix}-${var.environment}-web-ag-publicip-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

locals {
  # Generic
  frontend_port_name             = "${azurerm_virtual_network.vnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet.name}-feip"
  listener_name                  = "${azurerm_virtual_network.vnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.vnet.name}-rqrt"

  # App1
  backend_address_pool_name = "${azurerm_virtual_network.vnet.name}-beap"
  http_setting_name        = "${azurerm_virtual_network.vnet.name}-be-htst"
  probe_name               = "${azurerm_virtual_network.vnet.name}-be-probe"
}

resource "azurerm_application_gateway" "web_ag" {
  name                = "${var.resource_prefix}-${var.environment}-ag"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 0
    max_capacity = 10
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-config"
    subnet_id = azurerm_subnet.agsubnet.id
  }

  frontend_port {
    name = local.frontend_port_name  # تم التصحيح هنا
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.web_ag_publicip.id
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  backend_address_pool {
    name = local.backend_address_pool_name  # تم توحيد الاسم
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 8501
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = local.probe_name  # تم توحيد الاسم
  }

  probe {
    name                = local.probe_name
    host                = "127.0.0.1"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    protocol            = "Http"
    port                = 8501
    path                = "/"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name  # تم التصحيح هنا (كان يشير إلى backend pool)
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}
