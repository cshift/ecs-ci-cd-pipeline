locals {
  codebuild_destroy_trigger_flag = data.terraform_remote_state.codebuild.outputs == {} ? true : false
  region                         = var.region
  tags                           = merge(var.tags, { Owner = var.owner, Environment = var.env })

  ########## CODEPIPELINE ###########
  codepipeline_name                   = format("%s-pipeline", var.name)
  codepipeline_github_connection_name = format("%s-github-connection", var.name)
  codepipeline_s3_artifact_name       = format("%s-artifact-s3", var.name)

  suorce_provider = var.suorce_provider
  // codepipeline_source_config_github = {
  //   ConnectionArn    = local.codebuild_destroy_trigger_flag == true ? null : aws_codestarconnections_connection.this[0].arn
  //   FullRepositoryId = var.GitHubFullRepositoryId
  //   BranchName       = var.GitHubBranchName
  // }
  codepipeline_source_config_codecommit = {
    RepositoryName = var.CodeCommitRepositoryName
    BranchName     = var.CodeCommitBranchName
  }
  codepipeline_build_config = {
    ProjectName = local.codebuild_name
  }
  codepipeline_deploy_config = {
    ClusterName = local.ecs_cluster_id
    ServiceName = local.ecs_service_name
  }


  ############### ECS ###############
  ecs_cluster_id   = data.terraform_remote_state.ecs.outputs.ecs_cluster_id[0]
  ecs_service_name = data.terraform_remote_state.ecs.outputs.ecs_service_name[0]
  ############### VPC ###############
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_ids  = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  azs                = data.terraform_remote_state.vpc.outputs.azs
  default_sg_id      = data.terraform_remote_state.vpc.outputs.default_security_group_id
  codebuild_name     = local.codebuild_destroy_trigger_flag == true ? null : data.terraform_remote_state.codebuild.outputs.name
  ############### IAM ###############
  role_name               = format("%s-pipeline-role", var.name)
  trusted_role_services   = var.trusted_role_services
  custom_role_policy_arns = var.custom_role_policy_arns
}

