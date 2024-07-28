variable "AZ_RESOURCE_GROUP_NAME" {
  type        = string
  description = "Resource group name."
}

variable "LZ_NAME" {
  description = "Name of the landing zone"
  type        = string
  default = "XTech"
}

variable "ENVIRONMENT" {
  description = "Code of the environment. d - p"
  type        = string
}

variable "APP_INSIGHTS_NAME" {
  type = string
  description = "APP INSIGHTS NAME"
}

variable "ARM_CLIENT_SECRET" {
  type = string
  sensitive = true
}

variable "ARM_SUBSCRIPTION_ID" {
  type = string
}