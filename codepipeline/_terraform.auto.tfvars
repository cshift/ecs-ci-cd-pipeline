env   = "dev"
name  = "dev-dc"
owner = "dc"
tags  = {}

####### CODEPIPELINE #######
suorce_provider = "CodeCommit"
# GitHub
GitHubFullRepositoryId = "DACHANCHOI/test"
GitHubBranchName       = "main"
# CodeCommit
CodeCommitRepositoryName = "test"
CodeCommitBranchName     = "master"

############## IAM #############
trusted_role_services = ["codepipeline.amazonaws.com"]
custom_role_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  "arn:aws:iam::aws:policy/AWSCodeStarFullAccess",
  "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess",
  "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess",
  "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
  "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
]

