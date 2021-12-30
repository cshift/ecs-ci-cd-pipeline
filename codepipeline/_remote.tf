data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "ecs-cicd-pipeline-0"

    workspaces = {
      name = "ecs-vpc"
    }
  }
}
data "terraform_remote_state" "ecs" {
  backend = "remote"

  config = {
    organization = "ecs-cicd-pipeline-0"

    workspaces = {
      name = "ecs"
    }
  }
}
data "terraform_remote_state" "codebuild" {
  backend = "remote"

  config = {
    organization = "ecs-cicd-pipeline-0"

    workspaces = {
      name = "aws-codebuild"
    }
  }
}