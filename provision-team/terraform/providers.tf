terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.77.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = local.resource_group_name
    storage_account_name = local.storage_account_name
    container_name       = local.tfstate_container_name
    key                  = "terraform.tfstate"
    access_key           = local.storage_account_access_key
  }
}

provider "azurerm" {
  features {
  }
}

data "azurerm_client_config" "current" {}