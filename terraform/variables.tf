variable "db_password" {
  description = "Admin password for the PostgreSQL flexible server"
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "The Subscription ID for the Azure account"
  type        = string
}
