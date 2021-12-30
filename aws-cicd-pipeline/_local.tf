locals {
  ecs_destroy_trigger_flag = data.terraform_remote_state.ecs.outputs == {} ? true : false
  region                   = var.region

  ########## CODEPIPELINE ###########
  codepipeline_name                   = format("%s-pipeline", var.cpl_name)
  codepipeline_source_connection_name = format("%s-github-connection", var.cpl_name)
  codepipeline_s3_artifact_name       = format("%s-artifact-s3", var.cpl_name)
  suorce_provider                     = var.suorce_provider
  // codepipeline_source_config_github = {
  //   ConnectionArn    = local.ecs_destroy_trigger_flag == true || local.suorce_provider == "CodeCommit" ? null : aws_codestarconnections_connection.this[0].arn
  //   FullRepositoryId = var.GitHubFullRepositoryId
  //   BranchName       = var.GitHubBranchName
  // }
  ## 미리 생성된 Github이 있을 경우
  codepipeline_source_config_github = {
    ConnectionArn    = local.ecs_destroy_trigger_flag == true || local.suorce_provider == "CodeCommit" ? null : var.ConnectionArn
    FullRepositoryId = var.GitHubFullRepositoryId
    BranchName       = var.GitHubBranchName
  }
  codepipeline_source_config_codecommit = {
    RepositoryName = var.CodeCommitRepositoryName
    BranchName     = var.CodeCommitBranchName
  }
  codepipeline_build_config = {
    ProjectName = local.codebuild_name
  }
  codepipeline_deploy_config_ECS = {
    ClusterName = local.ecs_cluster_id
    ServiceName = local.ecs_service_name
  }
  codepipeline_deploy_config_CodeDeploy = {
    ApplicationName                = local.app_name
    DeploymentGroupName            = local.deployment_group_name
    TaskDefinitionTemplateArtifact = "build_output"
    AppSpecTemplateArtifact        = "build_output"
  }

  cpl_tags = merge(var.cpl_tags, { Owner = var.owner, Environment = var.env })


  ################# ECS #################
  ecs_cluster_id        = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.ecs.outputs.ecs_cluster_id[0]
  ecs_service_name      = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.ecs.outputs.ecs_service_name[0]
  deployment_controller = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.ecs.outputs.deployment_controller
  ################# ALB #################
  alb_target_group_arns = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.ecs.outputs.alb_target_group_arns[0]
  listener_arns         = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.ecs.outputs.listener_arns[0]
  target_group_names    = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.ecs.outputs.target_group_names[0]
  listener_arns_blue    = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.ecs.outputs.listener_arns_blue[0]
  listener_arns_green   = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.ecs.outputs.listener_arns_green[0]
  target_group_blue     = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.ecs.outputs.target_group_blue[0]
  target_group_green    = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.ecs.outputs.target_group_green[0]


  ############## CODEDEPLOY #############
  app_name              = "${var.env}-${var.cd_app_name}"
  compute_platform      = var.compute_platform
  cd_app_tags           = merge(var.cd_app_tags, { Owner = var.owner, Environment = var.env })
  deployment_group_name = "${var.env}-${var.cd_group_name}"
  cd_group_tags         = merge(var.cd_group_tags, { Owner = var.owner, Environment = var.env })
  deployment_config_name = var.deployment_config_name
  ############## CODEBUILD ##############
  codebuild_name        = "${var.env}-${var.cb_name}"
  codebuild_timeout     = var.codebuild_timeout
  codebuild_envs        = var.codebuild_envs
  codebuild_cache_type  = var.codebuild_cache_type
  codebuild_cache_modes = var.codebuild_cache_modes
  source_type           = var.source_type
  artifact_type         = var.artifact_type
  cb_tags               = merge(var.cb_tags, { Owner = var.owner, Environment = var.env })


  ############ IAM ############
  role_name               = [format("%s-role", "${var.cb_name}"), format("%s-pipeline-role", var.cpl_name), format("%s-codedeploy-role", local.deployment_group_name)]
  trusted_role_services   = [var.cb_trusted_role_services, var.cpl_trusted_role_services, var.cd_trusted_role_services]
  custom_role_policy_arns = [var.cb_custom_role_policy_arns, var.cpl_custom_role_policy_arns, var.cd_custom_role_policy_arns]


  ################# VPC #################
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets            = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_group_ids = [data.terraform_remote_state.vpc.outputs.default_security_group_id]

}

