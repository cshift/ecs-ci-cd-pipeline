variable "env" {}
variable "name" {}
variable "owner" {}

########## CodeBuild ##########
variable "codebuild_timeout" {}
variable "codebuild_envs" {}
variable "codebuild_cache_type" {}
variable "codebuild_cache_modes" {}
variable "source_type" {}
variable "artifact_type" {}

############# IAM #############
variable "trusted_role_services" {}
variable "custom_role_policy_arns" {}

