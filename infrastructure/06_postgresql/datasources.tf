data "azurerm_client_config" "current" {
  
}

data "azurerm_resource_group" "rg" {
  name = var.AZ_RESOURCE_GROUP_NAME
}

data "azurerm_key_vault" "kv" {
  name = var.KV_NAME
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azuread_group" "env_contributor_group" {
  display_name = var.ENV_CONTRIBUTOR_GROUP_NAME
}

# data "azurerm_resource_group" "rg_vnet" {
#   name = var.RG_NETWORK_NAME
# }

# data "azurerm_virtual_network" "vnet_lz" {
#   name = var.VNET_NAME
#   resource_group_name = data.azurerm_resource_group.rg_vnet.name
# }

# data "azurerm_subnet" "subnet_endpoint" {
#   name = local.l_subnet_endpoint_name
#   virtual_network_name = data.azurerm_virtual_network.vnet_lz.name
#   resource_group_name = data.azurerm_resource_group.rg_vnet.name
# }

# data "azurerm_resource_group" "rg_public_dns_zone" {
#   name = var.RG_PUBLIC_DNS_ZONE_NAME
# }

# data "azurerm_dns_zone" "public_dns_zone_xtech" {
#   name = var.DNS_PUBLIC_NAME
#   resource_group_name = data.azurerm_resource_group.rg_public_dns_zone.name
# }