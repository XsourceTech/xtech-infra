# Config
data "azurerm_client_config" "current" {}

# Resource groups
data "azurerm_resource_group" "rg" {
  name = var.AZ_RESOURCE_GROUP_NAME
}

# Service principal
data "azuread_service_principal" "service_principal_builder" {
  display_name = var.SERVICE_PRINCIPAL_BUILDER
}

# Service principal env
# data "azuread_service_principal" "service_principal_env" {
#   display_name = "AZR-XTECH-Builder-${var.ENVIRONMENT_NAME}"
# }

# data "azuread_group" "env_owner_group" {
#   display_name = var.ENV_OWNER_GROUP_NAME
# }

# data "azuread_group" "env_contributor_group" {
#   display_name = var.ENV_CONTRIBUTOR_GROUP_NAME
# }