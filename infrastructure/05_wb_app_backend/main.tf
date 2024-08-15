locals {
  l_app_service_plan_name = format("asp-%s-xtech", var.ENVIRONMENT)
  l_web_app_name = format("wb-%s-xtech", var.ENVIRONMENT)

  ##### CORS - A list of origins which should be able to make cross-origin calls. * can be used to allow all calls.#####
  l_web_frontend_url = format("%s%s%s", "https://frontend-",var.ENVIRONMENT,"-xtech.azurewebsites.net")
  l_frontend_url = format("%s%s", var.FRONTEND_DNS_RECORD_NAME, var.DNS_ZONE_NAME)
  
  l_cors_allowed_origins = ["https://localhost:8080",local.l_frontend_url, local.l_web_frontend_url]
}

# ==============================================================================
# Create an App Service Plan with Linux
# ==============================================================================
resource "azurerm_service_plan" "appserviceplan" {
  name                = local.l_app_service_plan_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type = "Linux"
  sku_name = "S1"
}

# ==============================================================================
# Create an Backend Azure Web App for Containers in that App Service Plan
# ==============================================================================
resource "azurerm_linux_web_app" "backend" {
  depends_on = [
    azurerm_service_plan.appserviceplan
  ]

  name                = local.l_web_app_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only = true

  
  # Configure Docker Image to load on start
  site_config {
    always_on        = "true"
    health_check_path = "/api/v1/health"
    http2_enabled = true
    minimum_tls_version = 1.2

    cors {
      allowed_origins = local.l_cors_allowed_origins
      support_credentials = var.CORS_SUPPORT_CREDENTIALS
    }

    application_stack {
        docker_image_name = "nginx:latest"
#        docker_image_name = "${data.azurerm_container_registry.acr.login_server}/${var.CONTAINER_IMAGE}:${var.CONTAINER_IMAGE_TAG}"
        docker_registry_url = "https://${data.azurerm_container_registry.acr.login_server}"
        docker_registry_username = "${data.azurerm_container_registry.acr.admin_username}"
        docker_registry_password = "${data.azurerm_container_registry.acr.admin_password}"
  }
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      site_config[0].application_stack[0].docker_image_name
    ]
  } 
}

# ==============================================================================
# Continuous Deployment
# ==============================================================================
resource "azurerm_role_assignment" "acr_pull" {
  depends_on = [
    azurerm_linux_web_app.backend
  ]  
  principal_id   = azurerm_linux_web_app.backend.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope          = data.azurerm_container_registry.acr.id
}