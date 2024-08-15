variable "AZ_RESOURCE_GROUP_NAME" {
  type        = string
  description = "Resource group name."
}

variable "ENVIRONMENT" {
  description = "Code of the environment. i - p"
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