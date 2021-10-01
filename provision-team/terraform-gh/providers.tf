terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.15.1"
    }
  }
}

provider "github" {
  owner = var.gh_org
  token = var.gh_token
}
