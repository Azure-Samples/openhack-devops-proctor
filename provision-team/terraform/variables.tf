variable "resources_prefix" {
  description = ""
  type        = string
  default     = null
}
variable "tfstate_container_name" {
  description = ""
  type        = string
  default     = null
}
variable "resource_group_name" {
  description = ""
  type        = string
  default     = null
}
variable "storage_account_name" {
  description = ""
  type        = string
  default     = null
}
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