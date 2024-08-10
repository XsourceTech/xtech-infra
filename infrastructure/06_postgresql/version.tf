terraform {
  required_version = "1.9.4"

  required_providers {
    azurerm = "=3.115.0"
    postgresql = {
      source  = "younux/postgresql"
      version = "0.0.1"
    }
  }
}