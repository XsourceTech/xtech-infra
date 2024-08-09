locals {
  l_app_service_plan_name = format("asp-%s-xtech", var.ENVIRONMENT)
  l_web_app_name = format("wb-%s-xtech", var.ENVIRONMENT)
}
# Create an App Service Plan with Linux
resource "azurerm_service_plan" "appserviceplan" {
  name                = local.l_app_service_plan_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type = "Linux"
  sku_name = "S1"
}

# Create an Azure Web App for Containers in that App Service Plan
resource "azurerm_linux_web_app" "backend" {
  depends_on = [
    azurerm_service_plan.appserviceplan
  ]

  name                = local.l_web_app_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id

  
  # Configure Docker Image to load on start
  site_config {
    always_on        = "true"
    health_check_path = "/api/v1/health"

    application_stack {
        docker_registry_url = "https://${data.azurerm_container_registry.acr.login_server}"
        docker_registry_username = "${data.azurerm_container_registry.acr.admin_username}"
        docker_registry_password = "${data.azurerm_container_registry.acr.admin_password}"
  }
  }

  identity {
    type = "SystemAssigned"
  }
}

