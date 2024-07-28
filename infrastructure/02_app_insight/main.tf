locals {
  l_app_code = "${lower(var.LZ_NAME)}"
  l_log_analytics_workspace_name = format("workspace-logs-%s-xtech", var.ENVIRONMENT)
}


resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = local.l_log_analytics_workspace_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = data.azurerm_resource_group.rg.tags
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

// The application type other is for general use
// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights#application_type
resource "azurerm_application_insights" "application_insights" {
  name                = var.APP_INSIGHTS_NAME
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = data.azurerm_resource_group.rg.tags
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace.id
  application_type    = "other"
}
