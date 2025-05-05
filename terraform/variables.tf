variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "resource_group_location" {
  description = "Region in which Azure Resources to be created"
  type        = string
  default     = "eastus2"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true # إضافة علامة حساسة لأمان المعلومات
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

variable "ag_subnet_name" {
  description = "Name of the Application Gateway subnet"
  type        = string
  default     = "agsubnet"
}

variable "ag_subnet_address" {
  description = "Address space for Application Gateway subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}


variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev" # إضافة قيمة افتراضية
}

variable "tenant_id" {
  description = "Azure Tenant ID for Key Vault authentication"
  type        = string
  sensitive   = true # إضافة علامة حساسة لأمان المعلومات
}

variable "object_id" {
  description = "Azure Object ID for Key Vault Access Policy"
  type        = string
  sensitive   = true # إضافة علامة حساسة لأمان المعلومات
}


variable "vm_admin_username" {
  description = "Admin username for virtual machines"
  type        = string
  default     = "azureuser"
}

variable "vm_sku_size" {
  description = "The size of the VM"
  type        = string
  default     = "Standard_B2ms"
}

variable "vmss_instance_count" {
  description = "Number of VM instances in the scale set"
  type        = number
  default     = 2
}

variable "resource_prefix" {
  description = "Prefix for all resource names (3-6 characters recommended)"
  type        = string
  default     = "chatbot"
}

variable "unique_suffix" {
  description = "Random string suffix for unique resource naming"
  type        = string
  default     = null # سيتم توليده تلقائياً إذا لم يتم تحديده
}

