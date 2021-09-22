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
  resource_group_name  = "${local.resources_prefix}staterg"
  storage_account_name = "${local.resources_prefix}statest"
  tfstate_key          = "terraform.tfstate"
  gh_repo_name     = var.gh_repo_name
}