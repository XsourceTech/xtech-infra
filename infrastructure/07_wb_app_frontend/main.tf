
locals {
  l_app_service_plan_name = format("asp-%s-xtech", var.ENVIRONMENT)
  l_frontend_app_name = format("frontend-%s-xtech", var.ENVIRONMENT)
}

# ==============================================================================
# Create an Backend Azure Web App for Containers in that App Service Plan
# ==============================================================================
resource "azurerm_linux_web_app" "frontend" {
  name                = local.l_frontend_app_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = data.azurerm_service_plan.asp.id
  https_only = true
  
  # Configure Docker Image to load on start
  site_config {
    always_on        = "true"
    health_check_path = "/frontend/v1/health"
    minimum_tls_version = 1.2
    http2_enabled = true

    application_stack {
        docker_image_name = "nginx:latest"
        docker_registry_url = "https://${data.azurerm_container_registry.acr.login_server}"
        docker_registry_username = "${data.azurerm_container_registry.acr.admin_username}"
        docker_registry_password = "${data.azurerm_container_registry.acr.admin_password}"
        }
  }

  identity {
    type = "SystemAssigned"
  }
}


# ==============================================================================
# CREATE DNS ZONE IN RG ROOT
# # ==============================================================================
resource "azurerm_dns_zone" "xsource" {
  name                = "xsource.com"
  resource_group_name = data.azurerm_resource_group.rg_root.name
}

# ==============================================================================
# CREATE DNS CNAME RECORD FOR FRONTEND
# # ==============================================================================
resource "azurerm_dns_cname_record" "example" {
  depends_on = [
    azurerm_dns_zone.xsource
  ]
  name                = var.FRONTEND_DNS_RECORD_NAME
  zone_name           = azurerm_dns_zone.xsource.name
  resource_group_name = data.azurerm_resource_group.rg_root.name
  ttl                 = 3600

  target_resource_id = azurerm_linux_web_app.frontend.id

  tags = data.azurerm_resource_group.rg.tags
}

