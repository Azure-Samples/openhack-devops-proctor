############################################
## RESOURCE GROUP                         ##
############################################

resource "azurerm_resource_group" "resource_group" {
  name     = local.resource_group_name
  location = local.location
}

############################################
## STORAGE ACCOUNT                        ##
############################################

resource "azurerm_storage_account" "storage_account" {
  name                      = local.storage_account_name
  resource_group_name       = azurerm_resource_group.resource_group.name
  location                  = azurerm_resource_group.resource_group.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

############################################
## AZURE DEVOPS                           ##
############################################

data "azuredevops_project" "ado_project" {
  name = local.ado_project_name
}

resource "azuredevops_variable_group" "variablegroup" {
  project_id   = data.azuredevops_project.ado_project.id
  name         = "tfstate"
  description  = "tfstate access data"
  allow_access = true

  variable {
    name  = "RESOURCES_PREFIX"
    value = local.resources_prefix
  }

  variable {
    name  = "TFSTATE_RESOURCES_GROUP_NAME"
    value = azurerm_resource_group.resource_group.name
  }

  variable {
    name  = "TFSTATE_STORAGE_ACCOUNT_NAME"
    value = azurerm_storage_account.storage_account.name
  }

  variable {
    name  = "TFSTATE_STORAGE_CONTAINER_NAME"
    value = azurerm_storage_container.storage_container.name
  }

  variable {
    name  = "TFSTATE_KEY"
    value = local.tfstate_key
  }
}