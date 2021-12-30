env   = "dev"
owner = "dc"

############## CodeBuild ##############
name  = "codebuild-ecs"
codebuild_timeout = "10"
codebuild_envs = {
  compute_type    = "BUILD_GENERAL1_SMALL"
  image           = "aws/codebuild/standard:4.0"
  type            = "LINUX_CONTAINER"
  privileged_mode = true
}
codebuild_cache_type  = "LOCAL"
codebuild_cache_modes = ["LOCAL_DOCKER_LAYER_CACHE"]
source_type           = "CODEPIPELINE"
artifact_type         = "CODEPIPELINE"
tags                  = {}

################# IAM #################
trusted_role_services = ["codebuild.amazonaws.com"]
custom_role_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
  "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
]

