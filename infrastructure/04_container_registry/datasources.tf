data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "rg" {
  name = var.AZ_RESOURCE_GROUP_NAME
}

# data "azuread_service_principal" "service_principal_env_int" {
#   display_name = var.SP_ENV_INT
# }

# data "azuread_service_principal" "service_principal_env_prod" {
#   display_name = var.SP_ENV_PROD
# }

# data "azuread_service_principal" "service_principal_env_qa" {
#   display_name = var.SP_ENV_QUAL
# }

data "azuread_service_principal" "service_principal_builder" {
  display_name = var.SERVICE_PRINCIPAL_BUILDER
}