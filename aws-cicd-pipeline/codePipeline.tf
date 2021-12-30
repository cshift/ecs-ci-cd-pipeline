resource "aws_codepipeline" "codepipeline" {
  count    = local.ecs_destroy_trigger_flag == true ? 0 : 1
  name     = local.codepipeline_name
  role_arn = module.iam[1].iam_role_arn
  artifact_store {
    location = local.codepipeline_s3_artifact_name
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = local.suorce_provider
      version          = "1"
      output_artifacts = ["source_output"]
      configuration    = local.suorce_provider == "CodeCommit" ? local.codepipeline_source_config_codecommit : local.codepipeline_source_config_github
    }
  }
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration    = local.codepipeline_build_config
    }
  }
  // stage {
  //   name = "Approve"
  //   action {
  //     name     = "Approval"
  //     category = "Approval"
  //     owner    = "AWS"
  //     provider = "Manual"
  //     version  = "1"
  //   }
  // }
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = local.deployment_controller == "ECS" ? "ECS" : "CodeDeployToECS"
      input_artifacts = ["build_output"]
      version         = "1"
      configuration   = local.deployment_controller == "ECS" ? local.codepipeline_deploy_config_ECS : local.codepipeline_deploy_config_CodeDeploy
    }
  }
  tags = merge(local.cpl_tags, { Name = local.codepipeline_name })
}

resource "aws_codestarconnections_connection" "this" {
  count         = local.ecs_destroy_trigger_flag == true || local.suorce_provider == "CodeCommit" ? 0 : 1
  name          = local.codepipeline_source_connection_name
  provider_type = "GitHub"
}
# s3
module "s3_artifact" {
  count         = local.ecs_destroy_trigger_flag == true ? 0 : 1
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = local.codepipeline_s3_artifact_name
  acl           = "private"
  force_destroy = true
  versioning    = { enabled = false }
  tags          = merge(local.cpl_tags, { Name = local.codepipeline_s3_artifact_name })
}