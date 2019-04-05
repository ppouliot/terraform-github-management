## Protect the master branch of the foo repository. Additionally, require that
## the "ci/travis" context to be passing and only allow the engineers team merge
## to the branch.
#resource "github_branch_protection" "gitops" {
#  repository = "${github_repository.gitops.name}"
#  branch = "master"
#  enforce_admins = true
#
#  required_status_checks {
#    strict = false
#    contexts = ["ci/travis"]
#  }
#
#  required_pull_request_reviews {
#    dismiss_stale_reviews = true
#    dismissal_users = ["foo-user"]
#    dismissal_teams = ["${github_team.gitops.slug}", "${github_team.second.slug}"]
#  }
#
#  restrictions {
#    users = ["foo-user"]
#    teams = ["${github_team.gitops.slug}"]
#  }
#}
