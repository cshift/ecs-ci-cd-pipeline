terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ecs-cicd-pipeline-0"

    workspaces {
      name = "aws-codebuild"

    }
  }
}