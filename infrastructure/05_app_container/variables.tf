variable "ARM_SUBSCRIPTION_ID" {
  type = string
}

variable "AZ_RESOURCE_GROUP_NAME" {
  type = string
}

variable "ENVIRONMENT" {
  description = "Code of the environment. d - p"
  type        = string
}

variable "CONTAINER_REGISTRY_NAME" {
  type = string
  description = "Name of ACR Env"
}

variable "ARM_CLIENT_SECRET" {
  type = string
  sensitive = true
}