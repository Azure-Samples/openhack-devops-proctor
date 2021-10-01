############################################
## GITHUB                                 ##
############################################

resource "github_team" "team" {
  name        = local.resources_prefix
  description = "${local.resources_prefix} team"
  privacy     = "secret"
}

resource "github_repository" "repo" {
  name         = local.resources_prefix
  visibility   = "private"
  has_issues   = true
  has_projects = true
  has_wiki     = true

  template {
    owner      = "Azure-Samples"
    repository = "openhack-devops-team"
  }
}

resource "github_team_repository" "team_repository" {
  team_id    = github_team.team.id
  repository = github_repository.repo.name
  permission = "admin"
}

# resource "github_organization_project" "project" {
#   name = local.resources_prefix
#   body = "${local.resources_prefix} organization project."
# }

resource "github_repository_project" "project" {
  name       = local.resources_prefix
  repository = github_repository.repo.name
  body       = "${local.resources_prefix} repository project."
}