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
