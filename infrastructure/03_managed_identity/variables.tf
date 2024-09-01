variable "AZ_RESOURCE_GROUP_NAME" {
  type = string
}

variable "KV_NAME" {
  type = string
}

variable "MODEL_MI_NAME" {
  type = string
}

variable "MODEL_MI_KV_SECRET_NAME" {
  type = string
}


variable "ARM_CLIENT_SECRET" {
  type = string
  sensitive = true
}

variable "ARM_SUBSCRIPTION_ID" {
  type = string
}