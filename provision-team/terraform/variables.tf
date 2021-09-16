variable "location" {
  description = ""
  type        = string
  default     = null
}
variable "mssql_server_administrator_login" {
  description = ""
  type        = string
  default     = null
  sensitive   = true
}
variable "mssql_server_administrator_login_password" {
  description = ""
  type        = string
  default     = null
  sensitive   = true
}
variable "bing_maps_key" {
  description = ""
  type        = string
  default     = null
}