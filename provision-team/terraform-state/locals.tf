resource "random_string" "uniquer" {
  length  = 6
  special = false
  number  = true
  lower   = false
  upper   = false
}

locals {
  resources_prefix     = var.resources_prefix != null ? var.resources_prefix : "devopsoh${random_string.uniquer.id}"
  location             = var.location != null ? var.location : local._default.location
  resource_group_name  = "${local.resources_prefix}rg"
  storage_account_name = "${local.resources_prefix}st"
  tfstate_key          = "terraform.tfstate"
  ado_project_name     = var.ado_project_name
}