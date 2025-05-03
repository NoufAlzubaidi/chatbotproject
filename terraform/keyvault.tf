resource "azurerm_key_vault" "kv" {
name = "local.resource-ame-refix−kv−{random_string.myrandom.id}"
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
enabled_for_disk_encryption = true
tenant_id = var.tenant_id
soft_delete_retention_days = 7
purge_protection_enabled = false
sku_name = "standard"

access_policy {
tenant_id = var.tenant_id
object_id = var.object_id

secret_permissions = [
  "Get",
  "List",
  "Set"
  
]
}
}

resource "azurerm_key_vault_secret" "db_credentials" {
name = "db-credentials"
value = "local.db- dministrator-ogin:{local.db_administrator_password}"
key_vault_id = azurerm_key_vault.kv.id
}

