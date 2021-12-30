locals {
  ecs_destroy_trigger_flag = data.terraform_remote_state.vpc.outputs == {} ? true : false
  region                   = var.region

  ############ ECS CLUSTER ############
  ecs_cluster_name   = "${var.env}-${var.ecs_cluster_name}"
  container_insights = var.container_insights
  capacity_providers = var.capacity_providers
  ecs_cluster_tags   = merge(var.ecs_cluster_tags, { Name = format("%s-ecs-cluster", var.env) })
  ######## ECS TASK DEFINITION ########
  family                     = "${var.env}-${var.family}"
  requires_compatibilities   = var.requires_compatibilities
  execution_role_arn         = var.execution_role_arn
  network_mode               = var.network_mode
  container_definitions_path = var.container_definitions_path
  cpu                        = var.cpu
  memory                     = var.memory
  ############# ECS SERVICE #############
  service_name             = var.service_name
  scheduling_strategy      = var.scheduling_strategy
  force_new_deployment     = var.force_new_deployment
  desired_count            = var.desired_count
  container_name           = var.container_name
  container_port           = var.container_port
  capacity_provider        = var.capacity_provider
  capacity_provider_weight = var.capacity_provider_weight
  capacity_provider_base   = var.capacity_provider_base
  deployment_controller    = var.deployment_controller

  ############### ALB ################
  load_balancer_type      = var.load_balancer_type
  alb_name                = "${var.env}-${var.alb_name}-${var.family}"
  http_sg_name            = format("%s-http-sg", "${var.env}-${var.alb_name}")
  target_group_name       = "tg-"
  http_tcp_listeners      = var.http_tcp_listeners
  http_tcp_listener_rules = var.http_tcp_listener_rules
  target_groups = [
    {
      name_prefix      = local.target_group_name
      backend_protocol = var.backend_protocol
      backend_port     = var.backend_port
      target_type      = var.target_type
    },
    {
      name_prefix      = local.target_group_name
      backend_protocol = var.backend_protocol
      backend_port     = var.backend_port
      target_type      = var.target_type
    }
  ]
  ################ VPC ################
  vpc_id             = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_ids  = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.vpc.outputs.public_subnet_ids
  private_subnet_ids = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.vpc.outputs.private_subnet_ids
  azs                = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.vpc.outputs.azs
  default_sg_id      = local.ecs_destroy_trigger_flag == true ? null : data.terraform_remote_state.vpc.outputs.default_security_group_id
  ########## SECURITY GROUP ###########
  http_sg_description      = var.http_sg_description
  http_ingress_cidr_blocks = var.http_ingress_cidr_blocks
  http_ingress_rules       = var.http_ingress_rules
  http_egress_rules        = var.http_egress_rules
}