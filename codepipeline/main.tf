resource "aws_codepipeline" "codepipeline" {
  count    = local.codebuild_destroy_trigger_flag == true ? 0 : 1
  name     = local.codepipeline_name
  role_arn = module.iam[0].iam_role_arn

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
      provider         = local.suorce_provider == "CodeCommit" ? "CodeCommit" : "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration    = local.codepipeline_source_config_codecommit
      // configuration    = local.codepipeline_source_config_gitbub
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
      provider        = "ECS"
      input_artifacts = ["build_output"]
      version         = "1"
      configuration   = local.codepipeline_deploy_config
    }
  }
}

// resource "aws_codestarconnections_connection" "this" {
//   count         = local.codebuild_destroy_trigger_flag == true ? 0 : 1
//   name          = local.codepipeline_github_connection_name
//   provider_type = "GitHub"
// }

# iam
module "iam" {
  count                   = local.codebuild_destroy_trigger_flag == true ? 0 : 1
  source                  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version                 = "~> 4.3"
  create_role             = true
  create_instance_profile = true
  role_name               = local.role_name
  role_requires_mfa       = false
  trusted_role_services   = local.trusted_role_services
  custom_role_policy_arns = local.custom_role_policy_arns
}

# s3
module "s3_artifact" {
  count         = local.codebuild_destroy_trigger_flag == true ? 0 : 1
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = local.codepipeline_s3_artifact_name
  acl           = "private"
  force_destroy = true
  versioning    = { enabled = false }
  tags          = merge(local.tags, { Name = local.codepipeline_s3_artifact_name })
}