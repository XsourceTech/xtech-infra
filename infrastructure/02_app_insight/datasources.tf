# Config
data "azurerm_client_config" "current" {}

# Resource groups
data "azurerm_resource_group" "rg" {
  name = var.AZ_RESOURCE_GROUP_NAME
}