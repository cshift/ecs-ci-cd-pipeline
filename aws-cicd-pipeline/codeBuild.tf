# codebuild
resource "aws_codebuild_project" "this" {
  count         = local.ecs_destroy_trigger_flag == true ? 0 : 1
  name          = local.codebuild_name
  build_timeout = local.codebuild_timeout
  service_role  = module.iam[0].iam_role_arn
  cache {
    type  = local.codebuild_cache_type
    modes = local.codebuild_cache_modes
  }
  source {
    type = local.source_type
  }
  artifacts {
    type = local.artifact_type
  }

  dynamic "environment" {
    for_each = length(keys(local.codebuild_envs)) == 0 ? [] : [local.codebuild_envs]
    content {
      compute_type    = environment.value.compute_type
      image           = environment.value.image
      type            = environment.value.type
      privileged_mode = environment.value.privileged_mode
    }
  }
  vpc_config {
    vpc_id             = local.vpc_id
    subnets            = local.subnets
    security_group_ids = local.security_group_ids
  }
  tags = local.cb_tags
}
