
locals {
  _default = {
    # location               = "westus2"
    base_image_tag = "changeme"
  }
  _secrets = {
    mssql_server_administrator_login          = "demousersa"
    mssql_server_administrator_login_password = "demo@pass123"
    bing_maps_key                             = "Ar6iuHZYgX1BrfJs6SRJaXWbpU_HKdoe7G-OO9b2kl3rWvcawYx235GGx5FPM76O"
  }
}