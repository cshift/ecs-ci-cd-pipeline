data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "amorepacific-ecs-cicd-pipeline-0"

    workspaces = {
      name = "ecs-vpc"
    }
  }
}
