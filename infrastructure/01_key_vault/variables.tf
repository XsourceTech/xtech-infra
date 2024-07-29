variable "AZ_RESOURCE_GROUP_NAME" {
  type        = string
  description = "Resource group name."
}

variable "ENVIRONMENT_NAME" {
  type        = string
}

variable "SERVICE_PRINCIPAL_BUILDER" {
  type = string
  description = "The name of service principal builder"
}

variable "KV_NAME" {
  type = string
  description = "The name of key vault"
}

variable "ENV_OWNER_GROUP_NAME" {
    type = string
    description = "The name of landing zone owner group"
}

variable "ENV_CONTRIBUTOR_GROUP_NAME" {
    type = string
    description = "The name of landing zone contributor group"
}

variable "ARM_CLIENT_SECRET" {
  type = string
  sensitive = true
}

variable "ARM_SUBSCRIPTION_ID" {
  type = string
}