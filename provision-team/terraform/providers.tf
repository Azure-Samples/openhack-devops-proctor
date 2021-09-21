terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.77.0"
    }
  }
  backend "azurerm" {
  }
  # backend "azurerm" {
  #   resource_group_name  = var.resource_group_name
  #   storage_account_name = var.storage_account_name
  #   container_name       = var.tfstate_container_name
  #   key                  = "terraform.tfstate"
  #   access_key           = var.storage_account_access_key
  # }
}

provider "azurerm" {
  features {
  }
}

data "azurerm_client_config" "current" {}