terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
  required_version = ">= 1.3.10"
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {

  }
}