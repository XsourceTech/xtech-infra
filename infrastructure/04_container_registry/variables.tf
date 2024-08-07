variable "ARM_SUBSCRIPTION_ID" {
  type = string
}

variable "AZ_RESOURCE_GROUP_NAME" {
  type = string
}

variable "CONTAINER_REGISTRY_NAME" {
  type = string
}

# variable "SP_ENV_INT" {
#   type = string
# }

# variable "SP_ENV_PROD" {
#   type = string
# }

# variable "SP_ENV_QUAL" {
#   type = string
# }

variable "SERVICE_PRINCIPAL_BUILDER" {
  type = string
}

variable "ARM_CLIENT_SECRET" {
  type = string
  sensitive = true
}

variable "ARM_SUBSCRIPTION_ID" {
  type = string
}