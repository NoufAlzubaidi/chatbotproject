resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "new-db"
  location               = azurerm_resource_group.main.location
  resource_group_name    = azurerm_resource_group.main.name
  administrator_login    = "adminuser"
  administrator_password = "yourStrongPassword123!"
  sku_name               = "B1ms"
  version                = "13"
  storage_mb             = 32768
  delegated_subnet_id    = azurerm_subnet.db_subnet.id
  zone                   = "1"

  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
  }
}
