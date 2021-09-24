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

resource "azurerm_role_assignment" "role_assignment_storage" {
  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

############################################
## GITHUB                                 ##
############################################

data "github_repository" "repo" {
  name = local.gh_repo_name
}

data "github_actions_public_key" "actions_public_key" {
  repository = data.github_repository.repo.name
}

resource "github_actions_secret" "actions_secret_resources_prefix" {
  repository      = data.github_repository.repo.name
  secret_name     = "RESOURCES_PREFIX"
  plaintext_value = local.resources_prefix
}

resource "github_actions_secret" "actions_secret_location" {
  repository      = data.github_repository.repo.name
  secret_name     = "LOCATION"
  plaintext_value = azurerm_resource_group.resource_group.location
}

resource "github_actions_secret" "actions_secret_resource_group_name" {
  repository      = data.github_repository.repo.name
  secret_name     = "TFSTATE_RESOURCES_GROUP_NAME"
  plaintext_value = azurerm_resource_group.resource_group.name
}

resource "github_actions_secret" "actions_secret_storage_account_name" {
  repository      = data.github_repository.repo.name
  secret_name     = "TFSTATE_STORAGE_ACCOUNT_NAME"
  plaintext_value = azurerm_storage_account.storage_account.name
}

resource "github_actions_secret" "actions_secret_storage_container_name" {
  repository      = data.github_repository.repo.name
  secret_name     = "TFSTATE_STORAGE_CONTAINER_NAME"
  plaintext_value = azurerm_storage_container.storage_container.name
}

resource "github_actions_secret" "actions_secret_tfstate_key" {
  repository      = data.github_repository.repo.name
  secret_name     = "TFSTATE_KEY"
  plaintext_value = local.tfstate_key
}