############################################
## RESOURCE GROUP                         ##
############################################

resource "azurerm_resource_group" "resource_group" {
  name     = local.resource_group_name
  location = local.location
}

############################################
## KEY VAULT                              ##
############################################

resource "azurerm_key_vault" "key_vault" {
  name                        = local.key_vault_name
  location                    = local.location
  resource_group_name         = local.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy_sp" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
    ]

    key_permissions = [
      "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"
    ]

    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
    ]

    storage_permissions = [
      "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"
    ]
}

############################################
## KEY VAULT SECRETS                      ##
############################################

resource "azurerm_key_vault_secret" "key_vault_secret_sqluser" {
  depends_on = [
    azurerm_key_vault_access_policy.key_vault_access_policy_sp
  ]
  name         = "SQLUSER"
  value        = local.mssql_server_administrator_login
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "key_vault_secret_sqlpassword" {
  depends_on = [
    azurerm_key_vault_access_policy.key_vault_access_policy_sp
  ]
  name         = "SQLPASSWORD"
  value        = local.mssql_server_administrator_login_password
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "key_vault_secret_sqlserver" {
  depends_on = [
    azurerm_key_vault_access_policy.key_vault_access_policy_sp
  ]
  name         = "SQLSERVER"
  value        = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "key_vault_secret_sqldbname" {
  depends_on = [
    azurerm_key_vault_access_policy.key_vault_access_policy_sp
  ]
  name         = "SQLDBNAME"
  value        = local.mssql_database_name
  key_vault_id = azurerm_key_vault.key_vault.id
}

############################################
## CONTAINER REGISTRY                     ##
############################################

resource "azurerm_container_registry" "container_registry" {
  name                = local.container_registry_name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku                 = "Standard"
  admin_enabled       = true
}

############################################
## SQL SERVER                             ##
############################################

resource "azurerm_mssql_server" "mssql_server" {
  name                         = local.mssql_server_name
  resource_group_name          = local.resource_group_name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = local.mssql_server_administrator_login
  administrator_login_password = local.mssql_server_administrator_login_password
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_firewall_rule" "mssql_firewall_rule_myip" {
  name             = "SetupAccountFWIP"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = local.mssql_firewall_rule_myip
  end_ip_address   = local.mssql_firewall_rule_myip
}

resource "azurerm_mssql_firewall_rule" "mssql_firewall_rule_azure" {
  name             = "AzureAccess"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_database" "mssql_database" {
  name      = local.mssql_database_name
  server_id = azurerm_mssql_server.mssql_server.id
  collation = "SQL_Latin1_General_CP1_CI_AS"
  sku_name  = "S0"
}

############################################
## APP SERVICE PLAN                       ##
############################################

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = local.app_service_plan_name
  location            = local.location
  resource_group_name = local.resource_group_name
  kind                = "linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

############################################
## SPP SERVICE - TRIPVIEWER               ##
############################################

resource "azurerm_app_service" "app_service_tripviewer" {
  depends_on = [
    null_resource.docker_tripviewer
  ]
  name                = local.app_service_tripviewer_name
  location            = local.location
  resource_group_name = local.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "BING_MAPS_KEY"      = local.bing_maps_key
    "USER_ROOT_URL"      = "https://${azurerm_app_service.app_service_api-userprofile.default_site_hostname}"
    "USER_JAVA_ROOT_URL" = "https://${azurerm_app_service.app_service_api-user-java.default_site_hostname}"
    "TRIPS_ROOT_URL"     = "https://${azurerm_app_service.app_service_api-trips.default_site_hostname}"
    "POI_ROOT_URL"       = "https://${azurerm_app_service.app_service_api-poi.default_site_hostname}"
    # "DOCKER_ENABLE_CI"           = "true"
    "DOCKER_REGISTRY_SERVER_URL" = "https://${azurerm_container_registry.container_registry.login_server}"
  }

  site_config {
    acr_use_managed_identity_credentials = true
    always_on                            = true
    linux_fx_version                     = "DOCKER|${azurerm_container_registry.container_registry.login_server}/devopsoh/tripviewer:latest"
  }
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy_tripviewer" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = azurerm_app_service.app_service_tripviewer.identity.0.tenant_id
  object_id    = azurerm_app_service.app_service_tripviewer.identity.0.principal_id

  secret_permissions = [
    "Get"
  ]
}

resource "azurerm_role_assignment" "cr_role_assignment_tripviewer" {
  scope                = azurerm_container_registry.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_app_service.app_service_tripviewer.identity.0.principal_id
}

############################################
## APP SERVICE - API-POI                  ##
############################################

resource "azurerm_app_service" "app_service_api-poi" {
  depends_on = [
    null_resource.docker_api-poi,
    null_resource.db_seed
  ]
  name                = local.app_service_api-poi_name
  location            = local.location
  resource_group_name = local.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "WEBSITES_PORT"                     = "8080"
    "SQL_USER"                          = local.mssql_server_administrator_login
    "SQL_PASSWORD"                      = local.mssql_server_administrator_login_password
    "SQL_SERVER"                        = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
    "SQL_DBNAME"                        = local.mssql_database_name
    "CONTAINER_AVAILABILITY_CHECK_MODE" = "Off"
    # "DOCKER_ENABLE_CI"                  = "true"
    "DOCKER_REGISTRY_SERVER_URL" = "https://${azurerm_container_registry.container_registry.login_server}"
  }

  site_config {
    acr_use_managed_identity_credentials = true
    always_on                            = true
    linux_fx_version                     = "DOCKER|${azurerm_container_registry.container_registry.login_server}/devopsoh/api-poi:${local.base_image_tag}"
  }
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy_api-poi" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = azurerm_app_service.app_service_api-poi.identity.0.tenant_id
  object_id    = azurerm_app_service.app_service_api-poi.identity.0.principal_id

  secret_permissions = [
    "Get"
  ]
}

resource "azurerm_role_assignment" "cr_role_assignment_api-poi" {
  scope                = azurerm_container_registry.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_app_service.app_service_api-poi.identity.0.principal_id
}

############################################
## APP SERVICE - API-TRIPS                ##
############################################

resource "azurerm_app_service" "app_service_api-trips" {
  depends_on = [
    null_resource.docker_api-trips,
    null_resource.db_seed
  ]
  name                = local.app_service_api-trips_name
  location            = local.location
  resource_group_name = local.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "SQL_USER"                          = local.mssql_server_administrator_login
    "SQL_PASSWORD"                      = local.mssql_server_administrator_login_password
    "SQL_SERVER"                        = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
    "SQL_DBNAME"                        = local.mssql_database_name
    "CONTAINER_AVAILABILITY_CHECK_MODE" = "Off"
    # "DOCKER_ENABLE_CI"                  = "true"
    "DOCKER_REGISTRY_SERVER_URL" = "https://${azurerm_container_registry.container_registry.login_server}"
  }

  site_config {
    acr_use_managed_identity_credentials = true
    always_on                            = true
    linux_fx_version                     = "DOCKER|${azurerm_container_registry.container_registry.login_server}/devopsoh/api-trips:${local.base_image_tag}"
  }
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy_api-trips" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = azurerm_app_service.app_service_api-trips.identity.0.tenant_id
  object_id    = azurerm_app_service.app_service_api-trips.identity.0.principal_id

  secret_permissions = [
    "Get"
  ]
}

resource "azurerm_role_assignment" "cr_role_assignment_api-trips" {
  scope                = azurerm_container_registry.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_app_service.app_service_api-trips.identity.0.principal_id
}

############################################
## APP SERVICE - API-USER-JAVA            ##
############################################

resource "azurerm_app_service" "app_service_api-user-java" {
  depends_on = [
    null_resource.docker_api-user-java,
    null_resource.db_seed
  ]
  name                = local.app_service_api-user-java_name
  location            = local.location
  resource_group_name = local.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "SQL_USER"                          = local.mssql_server_administrator_login
    "SQL_PASSWORD"                      = local.mssql_server_administrator_login_password
    "SQL_SERVER"                        = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
    "SQL_DBNAME"                        = local.mssql_database_name
    "CONTAINER_AVAILABILITY_CHECK_MODE" = "Off"
    # "DOCKER_ENABLE_CI"                  = "true"
    "DOCKER_REGISTRY_SERVER_URL" = "https://${azurerm_container_registry.container_registry.login_server}"
  }

  site_config {
    acr_use_managed_identity_credentials = true
    always_on                            = true
    linux_fx_version                     = "DOCKER|${azurerm_container_registry.container_registry.login_server}/devopsoh/api-user-java:${local.base_image_tag}"
  }
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy_api-user-java" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = azurerm_app_service.app_service_api-user-java.identity.0.tenant_id
  object_id    = azurerm_app_service.app_service_api-user-java.identity.0.principal_id

  secret_permissions = [
    "Get"
  ]
}

resource "azurerm_role_assignment" "cr_role_assignment_api-user-java" {
  scope                = azurerm_container_registry.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_app_service.app_service_api-user-java.identity.0.principal_id
}

############################################
## APP SERVICE - API-USERPROFILE          ##
############################################

resource "azurerm_app_service" "app_service_api-userprofile" {
  depends_on = [
    null_resource.docker_api-userprofile,
    null_resource.db_seed
  ]
  name                = local.app_service_api-userprofile_name
  location            = local.location
  resource_group_name = local.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "SQL_USER"                          = local.mssql_server_administrator_login
    "SQL_PASSWORD"                      = local.mssql_server_administrator_login_password
    "SQL_SERVER"                        = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
    "SQL_DBNAME"                        = local.mssql_database_name
    "CONTAINER_AVAILABILITY_CHECK_MODE" = "Off"
    # "DOCKER_ENABLE_CI"                  = "true"
    "DOCKER_REGISTRY_SERVER_URL" = "https://${azurerm_container_registry.container_registry.login_server}"
  }

  site_config {
    acr_use_managed_identity_credentials = true
    always_on                            = true
    linux_fx_version                     = "DOCKER|${azurerm_container_registry.container_registry.login_server}/devopsoh/api-userprofile:${local.base_image_tag}"
  }
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy_api-userprofile" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = azurerm_app_service.app_service_api-userprofile.identity.0.tenant_id
  object_id    = azurerm_app_service.app_service_api-userprofile.identity.0.principal_id

  secret_permissions = [
    "Get"
  ]
}

resource "azurerm_role_assignment" "cr_role_assignment_api-userprofile" {
  scope                = azurerm_container_registry.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_app_service.app_service_api-userprofile.identity.0.principal_id
}

############################################
## CONTAINER GROUP - SIMULATOR            ##
############################################

resource "azurerm_container_group" "container_group_simulator" {
  depends_on = [
    null_resource.docker_simulator,
    null_resource.db_seed
  ]
  name                = local.container_group_simulator_name
  location            = local.location
  resource_group_name = local.resource_group_name
  ip_address_type     = "public"
  dns_name_label      = local.container_group_simulator_name
  os_type             = "Linux"

  image_registry_credential {
    username = azurerm_container_registry.container_registry.admin_username
    password = azurerm_container_registry.container_registry.admin_password
    server   = azurerm_container_registry.container_registry.login_server
  }

  container {
    name   = "simulator"
    image  = "${azurerm_container_registry.container_registry.login_server}/devopsoh/simulator:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      "SQL_USER"           = local.mssql_server_administrator_login
      "SQL_PASSWORD"       = local.mssql_server_administrator_login_password
      "SQL_SERVER"         = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
      "SQL_DBNAME"         = local.mssql_database_name
      "TEAM_NAME"          = local.team_name
      "USER_ROOT_URL"      = "https://${azurerm_app_service.app_service_api-userprofile.default_site_hostname}"
      "USER_JAVA_ROOT_URL" = "https://${azurerm_app_service.app_service_api-user-java.default_site_hostname}"
      "TRIPS_ROOT_URL"     = "https://${azurerm_app_service.app_service_api-trips.default_site_hostname}"
      "POI_ROOT_URL"       = "https://${azurerm_app_service.app_service_api-poi.default_site_hostname}"
    }
  }
}
