variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "resource_group_location" {
  description = "Region in which Azure Resources to be created"
  type        = string
  default     = "EastUS"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
  default     = "vnet-default"
}

variable "vnet_address_space" {
  description = "Virtual Network address_space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "web_subnet_name" {
  description = "Virtual Network Web Subnet Name"
  type        = string
  default     = "websubnet"
}

variable "web_subnet_address" {
  description = "Virtual Network Web Subnet Address Spaces"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "environment" {
  description = "value"
  type = string
}

variable "vmss_subnet_name" {
  description = "Virtual Network VMSS Subnet Name"
  type        = string
  default     = "vmsssubnet"
}

variable "vmss_subnet_address" {
  description = "Virtual Network VMSS Subnet Address Spaces"
  type        = list(string)
  default     = ["10.1.2.0/24"]
}

variable "ag_subnet_name" {
  description = "Application Gateway Subnet Name"
  type        = string
  default     = "agsubnet"
}

variable "ag_subnet_address" {
  description = "Application Gateway Subnet Address Spaces"
  type        = list(string)
  default     = ["10.1.3.0/24"]
}

variable "key_vault_name" {
  description = "Azure Key Vault name"
  type        = string
  default     = "mykv"
}
