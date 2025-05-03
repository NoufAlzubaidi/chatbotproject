# Define Local Values in Terraform
locals {
  environment          = var.environment
  resource_name_prefix = var.environment
  common_tags = {
    environment = local.environment
  }
}

resource "random_string" "myrandom" {
  length  = 3
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_name_prefix}-${var.resource_group_name}-${random_string.myrandom.id}"
  location = var.resource_group_location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.resource_name_prefix}-${var.vnet_name}-${random_string.myrandom.id}"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "websubnet" {
  name                 = "${azurerm_virtual_network.vnet.name}-${var.web_subnet_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.web_subnet_address
}

resource "azurerm_network_security_group" "web_subnet_nsg" {
  name                = "${azurerm_subnet.websubnet.name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg_associate" {
  depends_on                = [azurerm_network_security_rule.web_nsg_rule_inbound]
  subnet_id                 = azurerm_subnet.websubnet.id
  network_security_group_id = azurerm_network_security_group.web_subnet_nsg.id
}


locals {
  web_inbound_ports_map = {
    "120" = "22"
    "130" = "8501" # Streamlit port
  }
}

resource "azurerm_network_security_rule" "web_nsg_rule_inbound" {
  for_each                    = local.web_inbound_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.web_subnet_nsg.name
}

#Application Gateway subnet 
resource "azure_subnet" "agsubnet" {
name       = "${azurerm_virtual_network.vnet.name}-${var.ag_subnet_name}-${random_string.myrandom.id}"
resource_group_name = azurerm_resource_group.rg.name
resource_network_name = azurerm_virtual_network.vnet.name
address_prefixes = var.ag_subnet_address
}

#Network security group 
resource "azurerm_network_security_group" "ag_subnet_nsg" {
name   = "${azurerm_subnet.agsubnet.name}-nsg"
location = azurerm_resource_group.rg.location 
resource_group_name = azurerm_resource_group.rg.name
}

#Associate NSG and Subnet
resource "azurerm_subnet_network_security_group_associaation" "ag_subnet_nsg_associate" {
depends_on  = [azurerm_network_security_rule.ag_nsg_rule_inbound] #every nsg association will disassaciate nsg from subnet
subnet_id  = azure_subnet.agsubnet.id
network_security_group_id =  azurerm_network_security_group.ag_subnet_nsg.id 
}

#create nsg rules 
#locals block for security rules 
locals{
  ag_inbound_ports_map = {
  "100" : "80"
  "110" : "443"
  "130" : "65200-65535"
  }
}


resource "azurerm_network_security_rule" "ag_nsg_rule_inbound" {
  for_each                    = local.ag_inbound_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.ag_subnet_nsg.name
}
