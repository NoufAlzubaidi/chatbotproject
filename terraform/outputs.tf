output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "subnet_db_id" {
  value = azurerm_subnet.db_subnet.id
}

output "subnet_vmss_id" {
  value = azurerm_subnet.vmss_subnet.id
}

output "subnet_app_gateway_id" {
  value = azurerm_subnet.appgw_subnet.id
}

output "subnet_tf_vm_id" {
  value = azurerm_subnet.tf-vm_subnet.id
}

output "subnet_bastion_id" {
  value = azurerm_subnet.bastion_subnet.id
}

output "nsg_vmss_id" {
  value = azurerm_network_security_group.vmss_nsg.id
}

output "nsg_tf_vm_id" {
  value = azurerm_network_security_group.tf-vm_nsg.id
}

output "bastion_host_id" {
  value = azurerm_bastion_host.terraform.id
}
