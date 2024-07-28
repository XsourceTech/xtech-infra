resource "azurerm_key_vault" "key_vault" {
  name                        = var.KV_NAME
  location                    = data.azurerm_resource_group.rg.location
  resource_group_name         = data.azurerm_resource_group.rg.name
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  tags                        = data.azurerm_resource_group.rg.tags
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  access_policy {
    object_id = data.azuread_service_principal.service_principal_env.object_id
    tenant_id = data.azurerm_client_config.current.tenant_id
    key_permissions         = ["Get", "List", "Create"]
    secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Restore", "Recover", "Purge"]
    storage_permissions     = ["Get", "List"]
    certificate_permissions = ["Get", "List", "Update", "Import", "Delete", "Purge"]
  }

  access_policy {
    object_id = data.azuread_group.env_owner_group.object_id
    tenant_id = data.azurerm_client_config.current.tenant_id
    key_permissions         = ["Get", "List", "Create"]
    secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Restore", "Recover", "Purge"]
    storage_permissions     = ["Get", "List"]
    certificate_permissions = ["Get", "List", "Update", "Import", "Delete", "Purge"]
  }

  access_policy {
    object_id = data.azuread_group.env_contributor_group.object_id
    tenant_id = data.azurerm_client_config.current.tenant_id
    key_permissions         = ["Get", "List", "Create"]
    secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Restore", "Recover", "Purge"]
    storage_permissions     = ["Get", "List"]
    certificate_permissions = ["Get", "List", "Update", "Import", "Delete", "Purge"]
  }

}