resource "random_string" "uniquer" {
  length  = 6
  special = false
  number  = true
  lower   = false
  upper   = false
}

data "external" "my_ip" {
  program = ["/bin/bash", "${path.module}/myip.sh"]
}

locals {
  _resources_prefix                         = "devopsoh${random_string.uniquer.id}"
  team_name                                 = local._resources_prefix
  location                                  = var.location != null ? var.location : local._default.location
  resource_group_name                       = "${local._resources_prefix}rg"
  key_vault_name                            = "${local._resources_prefix}kv"
  container_registry_name                   = "${local._resources_prefix}cr"
  mssql_server_name                         = "${local._resources_prefix}sql"
  mssql_server_administrator_login          = var.mssql_server_administrator_login != null ? var.mssql_server_administrator_login : local._secrets.mssql_server_administrator_login
  mssql_server_administrator_login_password = var.mssql_server_administrator_login_password != null ? var.mssql_server_administrator_login_password : local._secrets.mssql_server_administrator_login_password
  mssql_firewall_rule_myip                  = data.external.my_ip.result["my_ip"]
  mssql_database_name                       = "mydrivingDB"
  bing_maps_key                             = var.bing_maps_key != null ? var.bing_maps_key : local._secrets.bing_maps_key
  app_service_plan_name                     = "${local._resources_prefix}plan"
  app_service_tripviewer_name               = "${local._resources_prefix}tripviewer"
  app_service_api-poi_name                  = "${local._resources_prefix}poi"
  app_service_api-trips_name                = "${local._resources_prefix}trips"
  app_service_api-user-java_name            = "${local._resources_prefix}userjava"
  app_service_api-userprofile_name          = "${local._resources_prefix}userprofile"
  container_group_simulator_name            = "${local._resources_prefix}simulator"
  base_image_tag                            = local._default.base_image_tag
}