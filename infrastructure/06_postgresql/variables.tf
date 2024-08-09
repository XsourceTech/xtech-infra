variable "AZ_RESOURCE_GROUP_NAME" {
  type = string
}

variable "KV_NAME" {
  type = string
}

variable "PSQL_NAME" {
  type = string
}

variable "ADMIN_LOGIN_NAME" {
  type = string
  description = "The Administrator Login for the PostgreSQL Server"
  default = "postgresadmin"
}

variable "PSQL_SKU_NAME" {
  type        = string
  description = "Postgre server sizing"
  default     = "GP_Gen5_2"
}

variable "PSQL_VERSION" {
  type        = number
  description = "PostgreSQL version"
  default     = 11
}

variable "PSQL_STORAGE_MB" {
  type        = string
  description = "Number of mega bytes for the database"
  default     = 10240
}

variable "BACKUP_RETENTION_DAYS" {
  type        = number
  description = "Backup retention days number(min 7 max 35)"
  default     = 7
}

variable "GEO_REDUNDANT_BACKUP_ENABLED" {
  type        = bool
  description = "Locally redundant or geo redundant"
  default     = false
}

variable "AUTO_GROW_ENABLED" {
  type = bool
  description = <<DESCRIPTION
  (Optional) Enable/Disable auto-growing of the storage. 
  Storage auto-grow prevents your server from running out of storage and becoming read-only. 
  If storage auto grow is enabled, the storage automatically grows without impacting the workload. 
  The default value if not explicitly specified is true.
  DESCRIPTION
  default = true
}

# variable "ENV_CONTRIBUTOR_GROUP_NAME" {
#   type = string
# }

variable "PG_DBNAME" {
  type        = string
  description = "Postgre database name"
  default     = "xsource_db"
}

variable "DB_CHARSET" {
  type = string
  description = "Specifies the Charset for the PostgreSQL Database, which needs to be a valid PostgreSQL Charset. Changing this forces a new resource to be created."
  default     = "UTF8"
}

variable "DB_COLLATION" {
  type = string
  description = "Specifies the Collation for the PostgreSQL Database, which needs to be a valid PostgreSQL Collation. Note that Microsoft uses different notation - en-US instead of en_US. Changing this forces a new resource to be created."
  default     = "English_United States.1252"
}

# variable "BACKEND_DB_PRIVILEGES_GRANTED" {
#   type        = set(string)
#   description = "Privileges granted for backend application to the database"
#   default     = ["CREATE", "CONNECT", "TEMPORARY"]
# }

# variable "BACKEND_SCHEMA_PRIVILEGES_GRANTED" {
#   type        = set(string)
#   description = "Privileges granted for backend application to schema"
#   default     = ["CREATE", "USAGE"]
# }

# variable "BACKEND_TABLE_PRIVILEGES_GRANTED" {
#   type        = set(string)
#   description = "Privileges granted for backend application to tables"
#   default     = ["SELECT", "UPDATE", "INSERT", "DELETE"]
# }

# variable "BACKEND_SEQUENCE_PRIVILEGES_GRANTED" {
#   type        = set(string)
#   description = "Privileges granted for backend application to tables sequences"
#   default     = ["SELECT", "UPDATE", "USAGE"]
# }

# variable "DATA_DB_PRIVILEGES_GRANTED" {
#   type        = set(string)
#   description = "Privileges granted for read-only user to the database"
#   default     = ["CONNECT"]
# }

# variable "DATA_TABLE_PRIVILEGES_GRANTED" {
#   type        = set(string)
#   description = "Privileges granted for read-only user to tables"
#   default     = ["SELECT"]
# }

variable "ARM_CLIENT_SECRET" {
  type = string
  sensitive = true
}

variable "ARM_SUBSCRIPTION_ID" {
  type = string
}

variable "ENVIRONMENT" {
  type = string
}

# variable "APP_CODE" {
#   type = string
# }

# variable "VNET_NAME" {
#   type = string
# }

# variable "RG_NETWORK_NAME" {
#   type = string
# }

# variable "DNS_PUBLIC_NAME" {
#   type = string
# }

# variable "RG_PUBLIC_DNS_ZONE_NAME" {
#   type = string
# }

# variable "PSQL_DNS_A_RECORD_NAME" {
#   type = string
# }