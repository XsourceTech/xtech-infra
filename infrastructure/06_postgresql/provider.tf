provider "azurerm" {
  subscription_id = var.ARM_SUBSCRIPTION_ID
  features {}
}

provider "azuread" {
  
}

terraform {
  backend "azurerm" {}
}

provider "postgresql" {
  host                 = local.l_host_name
  port                 = 5432
  database             = var.PG_DBNAME
  username             = local.l_user_name
  database_username    = var.ENV_CONTRIBUTOR_GROUP_NAME
  password             = ""
  sslmode              = "require"
  aad_auth_enabled     = true
  aad_sp_client_id     = data.azurerm_client_config.current.client_id
  aad_sp_client_secret = var.ARM_CLIENT_SECRET
  aad_sp_tenant_id     = data.azurerm_client_config.current.tenant_id
  superuser            = false
}