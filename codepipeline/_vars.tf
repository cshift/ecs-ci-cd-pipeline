variable "env" {}
variable "name" {}
variable "owner" {}

########## CODEPIPELINE ###########
variable "suorce_provider" {}
variable "GitHubFullRepositoryId" {}
variable "GitHubBranchName" {}
variable "CodeCommitRepositoryName" {}
variable "CodeCommitBranchName" {}

############### IAM ###############
variable "trusted_role_services" {}
variable "custom_role_policy_arns" {}

