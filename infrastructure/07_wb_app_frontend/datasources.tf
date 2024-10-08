data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "rg" {
  name = var.AZ_RESOURCE_GROUP_NAME
}


data "azurerm_container_registry" "acr" {
  name                = var.CONTAINER_REGISTRY_NAME
  resource_group_name = var.AZ_RESOURCE_GROUP_NAME
}

data "azurerm_service_plan" "asp" {
  name                = local.l_app_service_plan_name
  resource_group_name = var.AZ_RESOURCE_GROUP_NAME
}

data "azurerm_resource_group" "rg_root" {
  name = var.AZ_RESOURCE_GROUP_ROOT_NAME
}