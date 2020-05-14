resource "azurerm_storage_account" "database" {
  name                     = "vcdevdbserverstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_server" "dbserver" {
  name                         = "vc-${var.name}-dbserver"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.db_login
  administrator_login_password = var.db_password

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.database.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.database.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }

  tags = {
    environment = "development"
  }
}

resource "azurerm_sql_firewall_rule" "main" {
  name                = "AlllowAzureServices"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.dbserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}