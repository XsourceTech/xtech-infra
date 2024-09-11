data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "rg" {
  name = var.AZ_RESOURCE_GROUP_NAME
}

data "azurerm_key_vault" "kv" {
  name = var.KV_NAME
  resource_group_name = var.AZ_RESOURCE_GROUP_NAME
}