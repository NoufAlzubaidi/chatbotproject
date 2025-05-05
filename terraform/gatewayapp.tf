resource "azurerm_public_ip" "web_ag_publicip" {
 name = "chatbot-${var.environment}-web-ag-publicip-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = "Static"
  sku = "Standard"
}


locals{
  #Generic 
  frontend_port_name = "${azurerm_virtual_network.vnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet.name}-feip"
  listener_name = "${azurerm_virtual_network.vnet.name}-httplstn"
  request_routing_rule1_name = "${azurerm_virtual_network.vnet.name}-rqrt-1"


  #App1 
  backend_address_pool_name_app1 = "${azurerm_virtual_network.vnet.name}-beap-app1"
  http_setting_name_app1 = "${azurerm_virtual_network.vnet.name}-be-htst-app1"
  probe_name_app1 = "${azurerm_virtual_network.vnet.name}-be-probe-app1"
}

#resource-2: Azure Application Gateway -standard 
resource "azurerm_application_gateway" "web_ag" {
  resource_group_name = azurerm_resource_group.rg.name
  location =   azurerm_resource_group.rg.location 

#START: -------------------------------#
#SKU: standard_v2  (new v)

sku { 
  name = "Standard_v2"
  tier = "Standard_v2"
}

autoscale_configuration { 
  min_capacity = 0
  max_capacity = 10
}

gateway_ip_configuration {
  name = "my_gateway_ip_configuration"
  subnet_id = azurerm_subnet.agsubnet.id
}

# Frontend configs
frontend_port {
  name = local.frontend_port.name
  port = 80
}

frontend_ip_configuration {
  name = local.frontend_ip_configuration_name
  public_ip_address_id = azurerm_public_ip.wbe_ag_publicip.id
}

#Listener : HTTP 80 
http_listener {
  name = local.listener_name 
  frontend_ip_configuration_name = local.frontend_ip_configuration_name
  frontend_port_name = local.frontend_port_name
  protocol = "Http"
}

#App1 configs
backend_address_pool { 
  name = local.backend_address_pool_name_app1
}

backend_http_settings {
  name = local.http_setting_name_app1
  cookie_based_affinity = "Disabled"
  port = 8501
  protocol = "Http"
  request_timeout = 60 
  probe_name = local.probe_name_app1 
}
probe {
  name =local.probe_name_app1
  host = "127.0.0.1"
  interval = 30 
  timeout = 30
  unhealthy_threshold = 3
  protocol = "Http"
  port = 8501
  path = "/"
}

# Rule-1 
request_routing_rule { 
  name = local.request_routing_rule1_name
  priority = 9 
  rule_type = "Basic"
  http_listener_name = local.backend_address_pool_name_app1
  backend_http_settings_name = local.http_setting_name_app1
}
}

