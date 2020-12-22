resource "azurerm_storage_account" "database" {
  name                     = "vcproddbserverstorage"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_server" "dbserver" {
  name                         = "vc-${var.name}-dbserver"
  resource_group_name          = var.resource_group_name
  location                     = var.location
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

resource "azurerm_sql_elasticpool" "pool" {
  name                = "vc-${var.name}-elasticpool"
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.dbserver.name
  edition             = "Standard"
  dtu                 = 50
  db_dtu_min          = 0
  db_dtu_max          = 10
  pool_size           = 51200
}

resource "azurerm_sql_firewall_rule" "main" {
  name                = "AlllowAzureServices"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.dbserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_firewall_rule" "all" {
  name                = "AlllowAllAccess"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.dbserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "azurerm_sql_active_directory_administrator" "access" {
  server_name         = azurerm_sql_server.dbserver.name
  resource_group_name = var.resource_group_name
  login               = var.ad_db_login
  tenant_id           = var.ad_tenant_id
  object_id           = var.ad_object_id
}