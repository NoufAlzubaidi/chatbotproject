variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "Norway East"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "terraform-sda"
}

variable "db_password" {
  description = "The administrator password for PostgreSQL server"
  type        = string
  sensitive   = true
}

variable "vm_admin_username" {
  description = "Admin username for virtual machines"
  type        = string
  default     = "azureuser"
}

variable "vm_admin_password" {
  description = "Admin password for virtual machines"
  type        = string
  sensitive   = true
}

variable "vmss_instance_count" {
  description = "Number of VMSS instances"
  type        = number
  default     = 2
}

variable "postgresql_sku" {
  description = "SKU for the PostgreSQL flexible server"
  type        = string
  default     = "B2ms"
}

variable "postgresql_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "16"
}

variable "storage_account_tier" {
  description = "Storage account tier (Standard/Premium)"
  type        = string
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Storage replication type (LRS/ZRS/GRS/etc.)"
  type        = string
  default     = "LRS"
}
variable "storage_account_tier" {
  default = "Standard"
}

variable "storage_replication_type" {
  default = "LRS"
}
