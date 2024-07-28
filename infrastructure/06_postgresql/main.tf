locals {
  l_psql_server_name = azurerm_postgresql_server.psql.name
  l_host_name = format("%s.postgres.database.azure.com", local.l_psql_server_name)
  
  l_user_name = format("%s%s%s", var.ENV_CONTRIBUTOR_GROUP_NAME, "@", local.l_psql_server_name)

  l_subnet_endpoint_name = format("subnet-endpoint-%s-%s", var.ENVIRONMENT, lower(var.APP_CODE))
}

# ==============================================================================
# RANDOM PASSWORD
# ==============================================================================
resource "random_password" "pws" {
  length = 30
  special = true
  override_special = "_%?!#()-[]<>,;*@="
  min_upper = 1
  min_lower = 1
  min_numeric = 1
  min_special = 1
}

resource "azurerm_key_vault_secret" "psql_login_pws" {
  depends_on = [
    random_password.pws
  ]

  name = "psql-admin-pws"
  value = random_password.pws.result
  key_vault_id = data.azurerm_key_vault.kv.id
}


# ==============================================================================
# PSQL SERVER
# ==============================================================================
resource "azurerm_postgresql_server" "psql" {
  name = var.PSQL_NAME
  location = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  administrator_login = var.ADMIN_LOGIN_NAME
  administrator_login_password = random_password.pws.result

  sku_name = var.PSQL_SKU_NAME
  version = var.PSQL_VERSION
  storage_mb = var.PSQL_STORAGE_MB

  backup_retention_days = var.BACKUP_RETENTION_DAYS
  geo_redundant_backup_enabled = var.GEO_REDUNDANT_BACKUP_ENABLED
  auto_grow_enabled = var.AUTO_GROW_ENABLED

  public_network_access_enabled = false
  ssl_enforcement_enabled = true
  ssl_minimal_tls_version_enforced = "TLS1_2"

  # identity {
  #   type = "SystemAssigned"
  # }

  tags = data.azurerm_resource_group.rg.tags
}


# ==============================================================================
# SET USER/GROUP AS AD ADMINISTRATOR FOR PSQL SERVER
# ==============================================================================
resource "azurerm_postgresql_active_directory_administrator" "psql_aad" {
  depends_on = [
    azurerm_postgresql_server.psql
  ]
  server_name = azurerm_postgresql_server.psql.name
  resource_group_name = data.azurerm_resource_group.rg.name
  login = data.azuread_group.env_contributor_group.display_name   #Use the Active Directory user/group name. It must contain the service principal of the resource group
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.env_contributor_group.object_id
}


# ==============================================================================
# SET PSQL CONFIGURATION VALUE ON PSQL SERVER
# ==============================================================================
resource "azurerm_postgresql_configuration" "connection_throttling" {
  name = "connection_throttling"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name = azurerm_postgresql_server.psql.name
  value = "on"
}

resource "azurerm_postgresql_configuration" "log_disconnections" {
  name = "log_disconnections"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name = azurerm_postgresql_server.psql.name
  value = "on"
}

resource "azurerm_postgresql_configuration" "log_checkpoints" {
  name = "log_checkpoints"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name = azurerm_postgresql_server.psql.name
  value = "on"
}

resource "azurerm_postgresql_configuration" "log_connections" {
  name = "log_connections"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name = azurerm_postgresql_server.psql.name
  value = "on"
}

resource "azurerm_postgresql_configuration" "log_duration" {
  name = "log_duration"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name = azurerm_postgresql_server.psql.name
  value = "on"
}


# ==============================================================================
# SET PSQL CONFIGURATION VALUE ON PSQL SERVER
# ==============================================================================
resource "azurerm_postgresql_firewall_rule" "authorize_azure_services_rule" {
  name = "AuthorizeAzureServices"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name = azurerm_postgresql_server.psql.name
  start_ip_address = "0.0.0.0"
  end_ip_address = "0.0.0.0"
}


# ==============================================================================
# PSQL DATABASE
# ==============================================================================
resource "azurerm_postgresql_database" "db" {
  depends_on = [
    azurerm_postgresql_server.psql
  ]
  name = var.PG_DBNAME
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name = azurerm_postgresql_server.psql.name
  charset = var.DB_CHARSET
  collation = var.DB_COLLATION
}


# ==============================================================================
# REGISTER KV SECRET 
# ==============================================================================
#Administrator username for the PostreSQL server
resource "azurerm_key_vault_secret" "database_username" {
  depends_on = [
    azurerm_postgresql_server.psql
  ]
  name = "PG-Database-Username"
  value = azurerm_postgresql_server.psql.administrator_login
  key_vault_id = data.azurerm_key_vault.kv.id
}


#Name for the PostreSQL database
resource "azurerm_key_vault_secret" "database_name" {
  depends_on = [
    azurerm_postgresql_database.db
  ]
  name = "PG-Database-Name"
  value = azurerm_postgresql_database.db.name
  key_vault_id = data.azurerm_key_vault.kv.id
}


#Host name for the PostreSQL 
resource "azurerm_key_vault_secret" "database_host" {
  name = "PG-Database-Host"
  value = local.l_host_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

#Port for the PostreSQL 
resource "azurerm_key_vault_secret" "database_port" {
  name = "PG-Database-Port"
  value = "5432"
  key_vault_id = data.azurerm_key_vault.kv.id
}


# ==============================================================================
# BACKEND 'ALL PRIVILEGES USER' ROLE TO ACCESS TO PSQL
# ==============================================================================
resource "random_password" "backend_user_pws" {
  length = 30
  special = true
  override_special = "_%?!#()-[]<>,;*@="
  min_upper = 1
  min_lower = 1
  min_numeric = 1
  min_special = 1
}

resource "azurerm_key_vault_secret" "backend_user_pws" {
  name = "backend-user-password-for-pgsql"
  value = random_password.backend_user_pws.result
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "backend_user_name" {
  name = "backend-user-username-for-pgsql"
  value = "all-privileges-user"
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "postgresql_role" "backend_user_role" {
  depends_on = [
    random_password.backend_user_pws
  ]
  name = "all-privileges-user"
  login = true
  password = random_password.backend_user_pws.result
}

resource "postgresql_grant_role" "grant_admin" {
  depends_on = [
    postgresql_role.backend_user_role
  ]
  role = postgresql_role.backend_user_role.name
  grant_role = "postgresadmin"
  with_admin_option = false
}

resource "postgresql_grant" "backend_grant_db_privileges" {
  depends_on = [
    azurerm_postgresql_database.db, postgresql_role.backend_user_role
  ]
  database = azurerm_postgresql_database.db.name
  role = postgresql_role.backend_user_role.name
  object_type = "database"
  privileges = var.BACKEND_DB_PRIVILEGES_GRANTED
}

resource "postgresql_grant" "backend_grant_schema_privileges" {
  depends_on = [
    azurerm_postgresql_database.db, postgresql_role.backend_user_role
  ]
  database = azurerm_postgresql_database.db.name
  role = postgresql_role.backend_user_role.name
  object_type = "schema"
  schema      = "public"
  privileges  = var.BACKEND_SCHEMA_PRIVILEGES_GRANTED
}

resource "postgresql_grant" "backend_grant_table_privileges" {
  depends_on = [
    azurerm_postgresql_database.db, postgresql_role.backend_user_role
  ]
  database = azurerm_postgresql_database.db.name
  role = postgresql_role.backend_user_role.name
  object_type = "table"
  schema      = "public"
  privileges  = var.BACKEND_TABLE_PRIVILEGES_GRANTED
}

resource "postgresql_grant" "backend_grant_sequence_privileges" {
  depends_on = [
    azurerm_postgresql_database.db, postgresql_role.backend_user_role
  ]
  database = azurerm_postgresql_database.db.name
  role = postgresql_role.backend_user_role.name
  object_type = "sequence"
  schema      = "public"
  privileges  = var.BACKEND_SEQUENCE_PRIVILEGES_GRANTED
}


# ==============================================================================
# READ_ONLY ROLE TO ACCESS TO ALL TABLES FOR DATA PIPELINE
# ==============================================================================
resource "random_password" "data_user_pws" {
  length = 30
  special = true
  override_special = "_%?!#()-[]<>,;*@="
  min_upper = 1
  min_lower = 1
  min_numeric = 1
  min_special = 1
}

resource "azurerm_key_vault_secret" "data_user_pws" {
  depends_on = [
    random_password.data_user_pws
  ]
  name = "data-user-password-for-pgsql"
  value = random_password.data_user_pws.result
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "data_user_name" {
  name = "data-user-username-for-pgsql"
  value = "read-only-user-role"
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "postgresql_role" "data_user_role" {
  depends_on = [
    random_password.data_user_pws
  ]
  name = "read-only-user-role"
  login = true
  password = random_password.data_user_pws.result
}

resource "postgresql_grant" "data_grant_database_privileges" {
  depends_on = [
    azurerm_postgresql_database.db, postgresql_role.data_user_role
  ]
  database = azurerm_postgresql_database.db.name
  role = postgresql_role.data_user_role.name
  object_type = "database"
  privileges  = var.DATA_DB_PRIVILEGES_GRANTED
}

resource "postgresql_grant" "data_grant_table_privileges" {
  depends_on = [
    azurerm_postgresql_database.db, postgresql_role.data_user_role
  ]
  database = azurerm_postgresql_database.db.name
  role = postgresql_role.data_user_role.name
  object_type = "table"
  schema      = "public"
  privileges  = var.DATA_TABLE_PRIVILEGES_GRANTED
}


# ==============================================================================
# PRIVATE ENDPOINT FOR PSQL
# ==============================================================================
resource "azurerm_private_endpoint" "psql_private_endpoint" {
  depends_on = [
    azurerm_postgresql_server.psql, azurerm_postgresql_database.db
  ]

  name = "psql-private-endpoint"
  location = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  subnet_id = data.azurerm_subnet.subnet_endpoint.id

  private_service_connection {
    name = "psql-private-connection"
    private_connection_resource_id = azurerm_postgresql_server.psql.id

    subresource_names = ["postgresqlServer"]
    is_manual_connection = false
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }

}


data "azurerm_private_endpoint_connection" "psql_private_endpoint_connection" {
  depends_on = [
    azurerm_private_endpoint.psql_private_endpoint
  ]

  name = azurerm_private_endpoint.psql_private_endpoint.name
  resource_group_name = data.azurerm_resource_group.rg.name
}


resource "azurerm_dns_a_record" "psql_dns_a_record" {
  depends_on = [
    azurerm_postgresql_server.psql,
    azurerm_postgresql_database.db,
    data.azurerm_private_endpoint_connection.psql_private_endpoint_connection
  ]

  name = var.PSQL_DNS_A_RECORD_NAME
  zone_name = data.azurerm_dns_zone.xtech.name
  resource_group_name = data.azurerm_resource_group.rg_public_dns_zone.name

  ttl = 3600

  records = [
    data.azurerm_private_endpoint_connection.psql_private_endpoint_connection.private_service_connection.0.private_ip_address
  ]

  tags = data.azurerm_resource_group.rg.tags
}



