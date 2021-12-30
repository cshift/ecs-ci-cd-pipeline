variable "env" {}
variable "owner" {}

########## CodeBuild ##########
variable "cb_name" {}
variable "codebuild_timeout" {}
variable "codebuild_envs" {}
variable "codebuild_cache_type" {}
variable "codebuild_cache_modes" {}
variable "source_type" {}
variable "artifact_type" {}
variable "cb_tags" {}
############# CB IAM #############
variable "cb_trusted_role_services" {}
variable "cb_custom_role_policy_arns" {}

########### CODEDEPLOY ############
variable "cd_app_name" {}
variable "cd_app_tags" {}
variable "compute_platform" {}
variable "cd_group_name" {}
variable "cd_group_tags" {}
variable "deployment_config_name" {}
############# CD IAM #############
variable "cd_trusted_role_services" {}
variable "cd_custom_role_policy_arns" {}


########## CODEPIPELINE ###########
variable "cpl_name" {}
variable "suorce_provider" {}
variable "CodeCommitRepositoryName" {}
variable "CodeCommitBranchName" {}
variable "GitHubFullRepositoryId" {}
variable "GitHubBranchName" {}
variable "ConnectionArn" {}
variable "cpl_tags" {}
############# CPL IAM #############
variable "cpl_trusted_role_services" {}
variable "cpl_custom_role_policy_arns" {}