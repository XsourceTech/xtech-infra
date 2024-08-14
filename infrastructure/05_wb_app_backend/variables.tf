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

variable "CORS_SUPPORT_CREDENTIALS" {
  description = "(Optional) Are credentials supported?"
  type        = bool
  default     = true
}

variable "DNS_ZONE_NAME" {
  type = string
}

variable "FRONTEND_DNS_RECORD_NAME" {
  type = string  
}