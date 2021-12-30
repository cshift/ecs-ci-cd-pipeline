variable "env" {}
variable "alb_name" {}
variable "owner" {}

############# ECS Cluster #############
variable "ecs_cluster_name" {}
variable "container_insights" {}
variable "capacity_providers" {}
variable "ecs_cluster_tags" {}
######### ECS Task Definition #########
variable "family" {}
variable "requires_compatibilities" {}
variable "execution_role_arn" {}
variable "network_mode" {}
variable "container_definitions_path" {}
variable "cpu" {}
variable "memory" {}
############# ECS Service #############
variable "service_name" {}
variable "scheduling_strategy" {}
variable "force_new_deployment" {}
variable "desired_count" {}
variable "container_name" {}
variable "container_port" {}
variable "capacity_provider" {}
variable "capacity_provider_weight" {}
variable "capacity_provider_base" {}
variable "deployment_controller" {}


################# ALB #################
variable "load_balancer_type" {}
variable "http_tcp_listeners" {}
variable "http_tcp_listener_rules" {}
variable "target_type" {}
variable "backend_protocol" {}
variable "backend_port" {}
########### Security Group ###########
variable "http_sg_description" {}
variable "http_ingress_cidr_blocks" {}
variable "http_ingress_rules" {}
variable "http_egress_rules" {}