
locals {
  l_app_service_plan_name = format("asp-%s-xtech", var.ENVIRONMENT)
  l_model_app_name = format("model-%s-xtech", var.ENVIRONMENT)
}

# ==============================================================================
# Create a Model Azure Web App for Containers 
# ==============================================================================
resource "azurerm_linux_web_app" "model" {
  name                = local.l_model_app_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = data.azurerm_service_plan.asp.id
  https_only = true

  
  # Configure Docker Image to load on start
  site_config {
    always_on        = "true"
    health_check_path = "/api/v1/health"
    http2_enabled = true
    minimum_tls_version = 1.2

    application_stack {
        docker_image_name = "${data.azurerm_container_registry.acr.login_server}/${var.CONTAINER_IMAGE_MODEL}:${var.CONTAINER_IMAGE_TAG_MODEL}"
        docker_registry_url = "https://${data.azurerm_container_registry.acr.login_server}"
        docker_registry_username = "${data.azurerm_container_registry.acr.admin_username}"
        docker_registry_password = "${data.azurerm_container_registry.acr.admin_password}"
  }
  }

  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      data.azurerm_user_assigned_identity.user_ai_model.id,
    ]
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
    azurerm_linux_web_app.model
  ]  
  principal_id   = azurerm_linux_web_app.model.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope          = data.azurerm_container_registry.acr.id
}