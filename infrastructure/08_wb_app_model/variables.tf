variable "ARM_SUBSCRIPTION_ID" {
  type = string
}

variable "AZ_RESOURCE_GROUP_NAME" {
  type = string
}

variable "ENVIRONMENT" {
  description = "Code of the environment. i - p"
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

variable "CONTAINER_IMAGE_MODEL" {
  type = string
  description = "Container image name"
}

variable "CONTAINER_IMAGE_TAG_MODEL" {
  type = string
  description = "Container image tag"  
}

variable "MODEL_MI_NAME" {
  type = string  
}