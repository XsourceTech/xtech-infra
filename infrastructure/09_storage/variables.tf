variable "ARM_SUBSCRIPTION_ID" {
  type = string
}

variable "AZ_RESOURCE_GROUP_NAME" {
  type = string
}

variable "ST_NAME" {
  type = string
}

variable "KV_NAME" {
  type = string
}

variable "ARM_CLIENT_SECRET" {
  type = string
  sensitive = true
}
