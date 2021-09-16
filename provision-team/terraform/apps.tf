
resource "null_resource" "git_team" {
  provisioner "local-exec" {
    command = "git clone https://github.com/DariuszPorowski/openhack-devops-team.git"
  }
}

############################################
## DOCKER                                 ##
############################################

resource "null_resource" "docker_tripviewer" {
  provisioner "local-exec" {
    command = "az acr build --image devopsoh/tripviewer:latest --registry ${azurerm_container_registry.container_registry.login_server} --file ../../tripviewer/Dockerfile ../../tripviewer"
  }
}

resource "null_resource" "docker_api-poi" {
  depends_on = [
    null_resource.git_team
  ]
  provisioner "local-exec" {
    command = "az acr build --image devopsoh/api-poi:${local.base_image_tag} --registry ${azurerm_container_registry.container_registry.login_server} --file openhack-devops-team/apis/poi/web/Dockerfile openhack-devops-team/apis/poi/web"
  }
}

resource "null_resource" "docker_api-trips" {
  depends_on = [
    null_resource.git_team
  ]
  provisioner "local-exec" {
    command = "az acr build --image devopsoh/api-trip:${local.base_image_tag} --registry ${azurerm_container_registry.container_registry.login_server} --file openhack-devops-team/apis/trips/Dockerfile openhack-devops-team/apis/trips"
  }
}

resource "null_resource" "docker_api-user-java" {
  depends_on = [
    null_resource.git_team
  ]
  provisioner "local-exec" {
    command = "az acr build --image devopsoh/api-user-java:${local.base_image_tag} --registry ${azurerm_container_registry.container_registry.login_server} --file openhack-devops-team/apis/user-java/Dockerfile openhack-devops-team/apis/user-java"
  }
}

resource "null_resource" "docker_api-userprofile" {
  depends_on = [
    null_resource.git_team
  ]
  provisioner "local-exec" {
    command = "az acr build --image devopsoh/api-userprofile:${local.base_image_tag} --registry ${azurerm_container_registry.container_registry.login_server} --file openhack-devops-team/apis/userprofile/Dockerfile openhack-devops-team/apis/userprofile"
  }
}

resource "null_resource" "docker_simulator" {
  depends_on = [
    null_resource.git_team
  ]
  provisioner "local-exec" {
    command = "az acr build --image devopsoh/simulator:latest --registry ${azurerm_container_registry.container_registry.login_server} --file ../../simulator/Dockerfile ../../simulator"
  }
}

############################################
## DATABASE                               ##
############################################

resource "null_resource" "db_schema" {
  depends_on = [
    azurerm_mssql_database.mssql_database
  ]
  provisioner "local-exec" {
    command = "sqlcmd -U ${local.mssql_server_administrator_login} -P ${local.mssql_server_administrator_login_password} -S ${azurerm_mssql_server.mssql_server.fully_qualified_domain_name} -d ${local.mssql_database_name} -i ../MYDrivingDB.sql -e"
  }
}

resource "null_resource" "db_seed" {
  depends_on = [
    null_resource.db_schema
  ]
  provisioner "local-exec" {
    command = "cd ..; bash ./sql_data_init.sh -s ${azurerm_mssql_server.mssql_server.fully_qualified_domain_name} -u ${local.mssql_server_administrator_login} -p ${local.mssql_server_administrator_login_password} -d ${local.mssql_database_name}; cd terraform"
  }
}

# resource "null_resource" "git_team_remove" {
#   depends_on = [
#     null_resource.docker_api-poi,
#     null_resource.docker_api-trips,
#     null_resource.docker_api-user-java,
#     null_resource.docker_api-userprofile
#   ]
#   provisioner "local-exec" {
#     command = "rm -r -f openhack-devops-team"
#   }
# }
