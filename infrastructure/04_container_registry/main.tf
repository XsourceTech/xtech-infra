# ==============================================================================
# Create Azure Container Registry
# ==============================================================================
resource "azurerm_container_registry" "acr" {
  name                = var.CONTAINER_REGISTRY_NAME
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = data.azurerm_resource_group.rg.tags
}


# ==============================================================================
# Grant sp acr env role to pull image
# ==============================================================================

resource "azurerm_role_assignment" "acrpull_role_sp_builder" {
  depends_on = [
    azurerm_container_registry.acr
  ]
  scope = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id = data.azuread_service_principal.service_principal_builder.id
}

resource "azurerm_role_assignment" "acrpull_role_sp_env_int" {
  depends_on = [
    azurerm_container_registry.acr
  ]
  scope = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id = data.azuread_service_principal.service_principal_env_int.id
}

resource "azurerm_role_assignment" "acrpull_role_sp_env_prod" {
  depends_on = [
    azurerm_container_registry.acr
  ]
  scope = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id = data.azuread_service_principal.service_principal_env_prod.id
}

resource "azurerm_role_assignment" "acrpull_role_sp_env_qa" {
  depends_on = [
    azurerm_container_registry.acr
  ]
  scope = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id = data.azuread_service_principal.service_principal_env_qa.id
}


# ==============================================================================
# Grant sp acr env role to push image
# ==============================================================================
resource "azurerm_role_assignment" "acrpush_role_sp_builder" {
  depends_on = [
    azurerm_container_registry.acr
  ]
  scope = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id = data.azuread_service_principal.service_principal_builder.id
}

resource "azurerm_role_assignment" "acrpush_role_sp_env_int" {
  depends_on = [
    azurerm_container_registry.acr
  ]

  scope = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id = data.azuread_service_principal.service_principal_env_int.id
}

resource "azurerm_role_assignment" "acrpush_role_sp_env_prod" {
  depends_on = [
    azurerm_container_registry.acr
  ]

  scope = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id = data.azuread_service_principal.service_principal_env_prod.id
}

resource "azurerm_role_assignment" "acrpush_role_sp_env_qa" {
  depends_on = [
    azurerm_container_registry.acr
  ]

  scope = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id = data.azuread_service_principal.service_principal_env_qa.id
}


