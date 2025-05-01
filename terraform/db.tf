resource "azurerm_postgresql_flexible_server" "main" {
  name                   = "tf-db"
  location               = var.location
  resource_group_name    = var.resource_group_name
  administrator_login    = "nouf"
  administrator_password = var.db_password
  sku_name               = var.postgresql_sku
  version                = var.postgresql_version
  storage_mb             = 32768

  delegated_subnet_id = azurerm_subnet.db_subnet.id
  zone                = "2"

  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
  }

  tags = {
    environment = "production"
  }

  depends_on = [azurerm_subnet.db_subnet]
}

resource "azurerm_postgresql_flexible_server_database" "chatdb" {
  name      = "chatdb"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}
