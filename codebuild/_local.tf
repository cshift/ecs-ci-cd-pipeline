locals {
  ecs_destroy_trigger_flag = data.terraform_remote_state.ecs.outputs == {} ? true : false
  region                   = var.region

  ############## CodeBuild ##############
  codebuild_name        = "${var.env}-${var.name}"
  codebuild_timeout     = var.codebuild_timeout
  codebuild_envs        = var.codebuild_envs
  codebuild_cache_type  = var.codebuild_cache_type
  codebuild_cache_modes = var.codebuild_cache_modes
  source_type           = var.source_type
  artifact_type         = var.artifact_type
  tags                  = merge(var.tags, { Owner = var.owner, Environment = var.env })
  
  
  ################# VPC #################
  vpc_id                = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets               = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_group_ids    = [data.terraform_remote_state.vpc.outputs.default_security_group_id]
  ################# IAM #################
  trusted_role_services   = var.trusted_role_services
  custom_role_policy_arns = var.custom_role_policy_arns
  role_name               = format("%srole", "${var.name}")
}