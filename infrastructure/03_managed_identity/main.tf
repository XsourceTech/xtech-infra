resource "azurerm_user_assigned_identity" "user_ai_model" {
  name = var.MODEL_MI_NAME

  resource_group_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  tags = data.azurerm_resource_group.rg.tags
}

resource "azurerm_key_vault_secret" "model_managed_identity_id" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name = var.MODEL_MI_KV_SECRET_NAME
  value = azurerm_user_assigned_identity.user_ai_model.id

  depends_on = [
    azurerm_user_assigned_identity.user_ai_model
  ]
}

resource "azurerm_key_vault_access_policy" "model_managed_identity_access" {
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_user_assigned_identity.user_ai_model.principal_id

  secret_permissions = [
    "Get", "List", "Set"
  ]

  depends_on = [
    azurerm_user_assigned_identity.user_ai_model
  ]
}