resource "azurerm_key_vault" "kv" {
  name                        = "${local.resource_name_prefix}-kv-${random_string.myrandom.id}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-admin-password"
  value        = var.db_administrator_password
  key_vault_id = azurerm_key_vault.kv.id
}

data "azurerm_client_config" "current" {}
