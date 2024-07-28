provider "azurerm" {
  subscription_id = var.ARM_SUBSCRIPTION_ID
  features {}
}

provider "azuread" {
}

terraform {
  backend "azurerm" {}
}
