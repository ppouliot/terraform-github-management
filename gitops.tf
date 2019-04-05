# GitOps Team and Repos

resource "github_team" "gitops" {
  name        = "gitops"
  description = "Github Operators"
  privacy     = "closed"
}
resource "github_membership" "gitops" {
  count    = "${length(var.gitops)}"
  username = "${var.gitops[count.index]}"
  role     = "admin"
}

data "github_user" "gitops" {
  username = "${var.gitops[count.index]}"
}
data "github_user" "users" {
  username = "${var.gitops[count.index]}"
}

# Create Keypair
resource "tls_private_key" "gitops-deploy-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "GitOps Deploy Key (Public Key): " {
  value = "${tls_private_key.gitops-deploy-key.public_key_openssh}"
}
output "GitOps Deploy Key (Private Key): " {
  value = "${tls_private_key.gitops-deploy-key.private_key_pem}"
}

# Add Member to GitOps Team
resource "github_team_membership" "gitops" {
  team_id  = "${github_team.gitops.id}"
  username = "${var.gitops[count.index]}"
  role     = "maintainer"
}

# GitOps Repo
resource "github_repository" "gitops" {
  name               = "gitops"
  description        = "${var.github_organization} gitops"
  homepage_url       = "${var.gitops_gh_pages_url}"
  has_issues         = "true"
  has_projects       = "true"
  has_wiki           = "true"
  license_template   = "apache-2.0"
  gitignore_template = "Terraform"
  auto_init          = "true"
}

# Add a collaborator to a repository
resource "github_repository_collaborator" "gitops" {
  count      = "${length(var.gitops)}"
  repository = "gitops"
  username   = "${var.gitops[count.index]}"
  permission = "admin"
  depends_on = ["github_repository.gitops"]
}

# Slack Web Hook
resource "github_repository_webhook" "gitops-slack" {
  events = [
    "*"
  ]
  name = "web"
  repository = "gitops"
  configuration {
    url          = "${var.slack_url}"
    content_type = "json"
    insecure_ssl = false
  }
  depends_on = [
    "github_repository.gitops",
  ]
}
# Add a deploy key to gitops repository
resource "github_repository_deploy_key" "gitops_repo_deploy_key" {
  title = "gitops-repo-deploy-key"
  repository = "gitops"
  key = "${tls_private_key.gitops-deploy-key.public_key_openssh}"
  read_only = "false"
  depends_on = [
    "github_repository.gitops",
  ]
}
