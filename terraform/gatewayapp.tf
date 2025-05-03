resource "azurerm_application_gateway" "app_gateway" {
name = "local.resource-ame-refix−appgw−{random_string.myrandom.id}"
resource_group_name = azurerm_resource_group.rg.name
location = azurerm_resource_group.rg.location

sku {
name = "Standard_v2"
tier = "Standard_v2"
capacity = 2
}

gateway_ip_configuration {
name = "appgw-ip-config"
subnet_id = azurerm_subnet.websubnet.id
}

frontend_port {
name = "http-port"
port = 80
}

frontend_port {
name = "https-port"
port = 443
}

frontend_ip_configuration {
name = "appgw-frontend-ip"
public_ip_address_id = azurerm_public_ip.web_vm_publicip.id
}

backend_address_pool {
name = "vmss-backend-pool"
}

backend_http_settings {
name = "http-settings"
cookie_based_affinity = "Disabled"
port = 80
protocol = "Http"
request_timeout = 60
}

http_listener {
name = "http-listener"
frontend_ip_configuration_name = "appgw-frontend-ip"
frontend_port_name = "http-port"
protocol = "Http"
}

request_routing_rule {
name = "http-rule"
rule_type = "Basic"
http_listener_name = "http-listener"
backend_address_pool_name = "vmss-backend-pool"
backend_http_settings_name = "http-settings"
priority = 100
}
}
