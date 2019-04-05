# Add a github_users to the organization

resource "github_team" "github_users" {
  name        = "github_users"
  description = "Github Users"
  privacy     = "closed"
}

resource "github_membership" "github_users" {
  count    = "${length(var.github_users)}"
  username = "${var.github_users[count.index]}"
  role     = "member"
}

data "github_user" "github_users" {
  count    = "${length(var.github_users)}"
  username = "${var.github_users[count.index]}"
}

# Create Keypair
resource "tls_private_key" "github_users-deploy-keys" {
  count     = "${length(var.github_users)}"
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "Github Deploy Key (Public Key):" {
  value = "${tls_private_key.github_users-deploy-keys.*.public_key_openssh}"
}
output "Github Deploy Key (Private Key):" {
  value = "${tls_private_key.github_users-deploy-keys.*.private_key_pem}"
}

# Team Membership

resource "github_team_membership" "github_users" {
  team_id  = "${github_team.github_users.id}"
  username = "${var.github_users[count.index]}"
  role     = "member"
}

# Create repository Dynamic User Repositories 

# Create repos
resource "github_repository" "github_users_repos" {
  count            = "${length(var.github_users)}"
  name             = "${var.github_users[count.index]}_repo"
  description      = "${var.github_users[count.index]} repository"
  auto_init        = "true"
  license_template = "apache-2.0"
# private          = true
  depends_on       = ["github_team_membership.github_users"]
}

# Set protection on github_users directories
resource "github_branch_protection" "github_users_repos" {
  count                         = "${length(var.github_users)}"
  repository                    = "${var.github_users[count.index]}_repo"
  branch                        = "master"
  enforce_admins                = "false"
  required_pull_request_reviews = {}
  depends_on                    = ["github_repository.github_users_repos"]
}

# Add a collaborator to a repository
resource "github_repository_collaborator" "github_users_repos" {
  count      = "${length(var.github_users)}"
  repository = "${var.github_users[count.index]}_repo"
  username   = "${var.github_users[count.index]}"
  permission = "push"
  depends_on = ["github_repository.github_users_repos"]
}

# Create labels
resource "github_issue_label" "github_users_repos" {
  count      = "${length(var.github_users) * length(var.github_labels) * var.github_labels_enable}"
  repository = "${var.github_users[count.index / length(var.github_labels)]}_repo"
  name       = "${var.github_labels[(count.index) % length(var.github_labels)]}"
  color      = "${var.github_color_labels}"
  depends_on = ["github_repository.github_users_repos"]
}

resource "github_issue_label" "github_users_repos_repost" {
  count      = "${length(var.github_users) * var.github_task_count  * var.github_labels_enable}"
  repository = "${var.github_users[count.index / var.github_task_count]}_repo"
  name       = "Task-${(count.index) % var.github_task_count + 1}"
  color      = "${var.github_color_tasks}"
  depends_on = ["github_repository.github_users_repos"]
}

# Add a deploy key to github users repository
resource "github_repository_deploy_key" "github_users-deploy-keys" {
  count      = "${length(var.github_users)}"
  title = "${var.github_users[count.index]}-deploy-key"
  repository = "${var.github_users[count.index]}_repo"
  key = "${tls_private_key.github_users-deploy-keys.*.public_key_openssh[count.index]}"
  read_only = "false"
  depends_on = ["tls_private_key.github_users-deploy-keys"]
}

# Slack Web Hook
resource "github_repository_webhook" "users-slack" {
  count  = "${length(var.github_users)}"
  events = [
    "*"
  ]
  name = "web"
  repository = "${var.github_users[count.index]}_repo"
  configuration {
    url          = "${var.slack_url}"
    content_type = "json"
    insecure_ssl = false
  }
  depends_on = ["github_repository.github_users_repos"]
}
