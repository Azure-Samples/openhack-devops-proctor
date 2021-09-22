variable "resources_prefix" {
  description = ""
  type        = string
  default     = null
}
variable "location" {
  description = ""
  type        = string
  default     = null
}
variable "ado_project_name" {
  description = ""
  type        = string
  default     = null
}
variable "ado_org_service_url" {
  description = ""
  type        = string
  default     = null
}
variable "ado_personal_access_token" {
  description = ""
  type        = string
  default     = null
  sensitive   = true
}