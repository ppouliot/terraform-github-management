# GitHub Provider

provider "github" {
  # Github Personal Access Token
  token        = "${var.github_personal_access_token}"

  # Set the Name of the Github Organization
  organization = "${var.github_organization}"
}
