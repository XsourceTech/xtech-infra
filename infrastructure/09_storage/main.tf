# ==============================================================================
# STORAGE ACCOUNT DATA
# ==============================================================================
resource "azurerm_storage_account" "st" {
  name = var.ST_NAME
  resource_group_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true
  min_tls_version = "TLS1_2"
  public_network_access_enabled = false
  
  identity {
    type = "SystemAssigned"
  }

  blob_properties {
    cors_rule {
      allowed_headers = ["*"]
      allowed_methods = ["DELETE", "GET", "HEAD", "POST", "OPTIONS", "PUT", "PATCH"]
      allowed_origins = ["*"]
      exposed_headers = ["*"]
      max_age_in_seconds = 3600
    }
  }
  tags = data.azurerm_resource_group.rg.tags
}


resource "azurerm_storage_container" "file-upload" {
  depends_on = [
    azurerm_storage_account.st
  ]

  name = "file-upload"

  storage_account_name = azurerm_storage_account.st.name
  container_access_type = "private"
}

# ==============================================================================
# STORAGE ACCOUNT ACCESS KEY IN KV
# ==============================================================================
resource "azurerm_key_vault_secret" "st-primary-key" {
  depends_on = [
    azurerm_storage_account.st
  ]
  name = "st-primary-key"
  value = azurerm_storage_account.st.primary_access_key
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "st-connection-string" {
  depends_on = [
    azurerm_storage_account.st
  ]

  name = "st-connection-string"
  value = azurerm_storage_account.st.primary_connection_string
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "st-data-name" {
  depends_on = [
    azurerm_storage_account.st
  ]

  name = "st-name"
  value = azurerm_storage_account.st.name
  key_vault_id = data.azurerm_key_vault.kv.id
}


