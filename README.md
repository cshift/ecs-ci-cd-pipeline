# ecs-ci-cd-pipeline
## Introduction

Terraform 코드로 통한 AWS ECS, Code Series를 프로비저닝

* #### **사전 준비사항**

  * Terraform Cloud or Terraform Open Source
  * AWS ECR Repository
  * [example container](https://github.com/cshift/example_ecs_service)

## Scenario

![image](https://user-images.githubusercontent.com/77256060/147801679-6aba0538-6765-41d9-aed4-1ee9998176dd.png)

1. Terraform으로 프로비저닝 ECS, ALB, CodePipeline, CodeBuild, CodeDeploy

2. CodePipeline Source Stage : GitHub 또는 CodeCommit 사용
   [환경변수 : suorce_provider](https://github.com/cshift/ecs-ci-cd-pipeline/blob/main/aws-cicd-pipeline/_terraform.auto.tfvars)

3. CodePipeline Build Stage : CodeBuild

4. CodePipeline Deploy Stage

   * Option #1 : CodePipeline 자체 배포
   * Option #2 : CodeDeploy를 통한 배포 (Recommand)
   [환경변수 : deployment_controller](https://github.com/cshift/ecs-ci-cd-pipeline/blob/main/ecs/terraform.auto.tfvars)

## Terraform Workspaces List

1. [**VPC**](https://github.com/cshift/ecs-ci-cd-pipeline/tree/main/vpc) 
2. [**ECS**](https://github.com/cshift/ecs-ci-cd-pipeline/tree/main/ecs)(ECS Cluster, ECS Task Definition, ECS Service, ALB)
3. [**AWS-CICD/PIPELINE**](https://github.com/cshift/ecs-ci-cd-pipeline/tree/main/aws-cicd-pipeline)(Codebuild, CodeDeploy, CodePipeline, CodeStar, CodeCommit)
4. CodeBuild (단일 워크스페이스)
5. CodeDeploy (단일 워크스페이스)
6. CodePipeline (단일 워크스페이스)

