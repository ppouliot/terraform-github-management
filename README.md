# terraform-github-management
Terraform to Manage GitHub Organizations

## Description
 
The idea is to manage a paid organization on Github.com.   Essenntially two groups are created, GitOps and Users, with Admin rights, and Member rights respectively.
Users get a dynamic project folder (Like a Home directory) which include a slack web hook as well as dynamic individual deploy keys on the repository as well.


## Files

* [gitops.tf](gitops.tf)
* [provider.tf](provider.tf)
* [users.tf](users.tf)
* [variables.tf](variables.tf)
