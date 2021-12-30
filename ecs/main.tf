module "http" {
  count               = local.ecs_destroy_trigger_flag == true ? 0 : 1
  source              = "terraform-aws-modules/security-group/aws"
  version             = "~> 4.0"
  name                = local.http_sg_name
  description         = local.http_sg_description
  vpc_id              = local.vpc_id
  ingress_cidr_blocks = local.http_ingress_cidr_blocks
  ingress_rules       = local.http_ingress_rules
  egress_rules        = local.http_egress_rules

}

module "alb" {
  count                   = local.ecs_destroy_trigger_flag == true ? 0 : 1
  source                  = "terraform-aws-modules/alb/aws"
  version                 = "~> 6.0"
  name                    = local.alb_name
  load_balancer_type      = local.load_balancer_type
  vpc_id                  = local.vpc_id
  security_groups         = [module.http[0].security_group_id, local.default_sg_id]
  subnets                 = local.public_subnet_ids
  http_tcp_listeners      = local.http_tcp_listeners
  http_tcp_listener_rules = local.http_tcp_listener_rules
  target_groups           = local.target_groups

}
module "ecs" {
  count              = local.ecs_destroy_trigger_flag == true ? 0 : 1
  source             = "terraform-aws-modules/ecs/aws"
  name               = local.ecs_cluster_name
  container_insights = local.container_insights
  capacity_providers = local.capacity_providers
  tags               = local.ecs_cluster_tags
}

resource "aws_ecs_task_definition" "dcc-test" {
  count                    = local.ecs_destroy_trigger_flag == true ? 0 : 1
  family                   = local.family
  requires_compatibilities = local.requires_compatibilities
  execution_role_arn       = local.execution_role_arn
  network_mode             = local.network_mode
  cpu                      = local.cpu
  memory                   = local.memory
  container_definitions    = file(local.container_definitions_path)
}

resource "aws_ecs_service" "example" {
  count                = local.ecs_destroy_trigger_flag == true ? 0 : 1
  name                 = local.service_name
  cluster              = module.ecs[0].ecs_cluster_id
  task_definition      = aws_ecs_task_definition.dcc-test[0].arn
  scheduling_strategy  = local.scheduling_strategy
  force_new_deployment = local.force_new_deployment
  desired_count        = local.desired_count

  network_configuration {
    subnets         = local.private_subnet_ids
    security_groups = [module.http[0].security_group_id, local.default_sg_id]

  }
  load_balancer {
    target_group_arn = module.alb[0].target_group_arns[0]
    container_name   = local.container_name
    container_port   = local.container_port
  }
  lifecycle {
    ignore_changes = [
      load_balancer,
      desired_count,
      task_definition,
    ]
  }
  capacity_provider_strategy {
    capacity_provider = local.capacity_provider
    weight            = local.capacity_provider_weight
    base              = local.capacity_provider_base
  }

  deployment_controller {
    type = local.deployment_controller
  }
}


