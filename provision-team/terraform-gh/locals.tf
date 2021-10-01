resource "random_string" "uniquer" {
  length  = 6
  special = false
  number  = true
  lower   = false
  upper   = false
}

locals {
  resources_prefix = var.resources_prefix != null ? var.resources_prefix : "devopsoh${random_string.uniquer.id}"
}