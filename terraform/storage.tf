resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

resource "azurerm_storage_account" "main" {
  name                     = "tfappstorage${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type
  allow_blob_public_access = false

  tags = {
    environment = "production"
  }
}

resource "azurerm_storage_container" "files" {
  name                  = "files"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "time_static" "now" {}

data "azurerm_storage_account_sas" "sas" {
  connection_string = azurerm_storage_account.main.primary_connection_string

  https_only      = true
  start           = time_static.now.rfc3339
  expiry          = timeadd(time_static.now.rfc3339, "8760h") # valid for 1 year
  resource_types  = ["o"]
  services        = ["b"]
  permissions     = "rwl"
}
