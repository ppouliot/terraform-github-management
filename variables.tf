# Terraform Variables
# ---------------------

# Github Organization
# ---------------------

variable "github_organization" {
  description = "Name of the GitHub organization"
}

# Github Personal Access Token
# -----------------------------

variable "github_personal_access_token" {
  description = "Github Personal Access Token"
}

# Github Operators
# ---------------------

variable "gitops" {
  description = "Github Operators List"
  type        = "list"
  default     = []
}

# Github Users
# ------------
variable "github_users" {
  description = "Github Users List"
  type        = "list"
  default     = []
}

# Slack Url for Github.com WebHooks
# ---------------------------------
variable "slack_url" {
  description = "Slack Url for Github Webhooks"
}

# Github GitOps GH-Pages URL
variable "gitops_gh_pages_url" {
  description = "Github GitOps Homepage URL"
}

# Github Labels
variable "github_labels" {
  description = "A List of Labels for Each Repo"
  type        = "list"
  default     = ["provision", "test", "destroy", "_⭐_"]
}

variable "github_task_count" {
  description = "Github Tasks count"
  default     = 10
}

variable "github_color_labels" {
  description = "Github Labels Color"
  default     = "00CCCC"
}

variable "github_color_tasks" {
  description = "Task Labels Color"
  default     = "CC6600"
}

variable "github_labels_enable" {
  description = "Github Enable Labels"
  default     = 1
}

