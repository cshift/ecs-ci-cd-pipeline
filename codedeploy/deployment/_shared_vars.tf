variable "backend_s3" {
  default = "devops-tfbackend-dc"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "vpc_key" {
  default = "dev/apne2/network/vpc/terraform.tfstate"
}

variable "tags" {}

variable "ecs_key" {
  default = "dev/apne2/infra/ecs/terraform.tfstate"
}
variable "codedeploy_app_key" {
  default = "dev/apne2/codeseries/codedeploy-app/terraform.tfstate"
}
