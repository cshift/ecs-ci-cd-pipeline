output "alb_sg_id" {
  value = local.ecs_destroy_trigger_flag == true ? null : module.http[*].security_group_id
}

output "alb_endpoint" {
  value = local.ecs_destroy_trigger_flag == true ? null : module.alb[*].lb_dns_name
}

output "alb_arn" {
  value = local.ecs_destroy_trigger_flag == true ? null : module.alb[*].lb_arn
}

output "alb_id" {
  value = local.ecs_destroy_trigger_flag == true ? null : module.alb[*].lb_id
}

output "alb_target_group_arns" {
  value = local.ecs_destroy_trigger_flag == true ? null : module.alb[*].target_group_arns
}
output "listener_arns" {
  value = local.ecs_destroy_trigger_flag == true ? null : module.alb[*].http_tcp_listener_arns
}
output "target_group_names" {
  value = local.ecs_destroy_trigger_flag == true ? null : module.alb[*].target_group_names
}

output "ecs_service_name" {
  value = local.ecs_destroy_trigger_flag == true ? null : aws_ecs_service.example[*].name
}

output "ecs_cluster_id" {
  value = local.ecs_destroy_trigger_flag == true ? null : module.ecs[*].ecs_cluster_name
}
output "deployment_controller" {
  value = local.deployment_controller
}
output "listener_arns_blue" {
  value = local.ecs_destroy_trigger_flag == true ? null : module.alb[*].http_tcp_listener_arns[0]
}
output "listener_arns_green" {
  value = local.ecs_destroy_trigger_flag == true ? null : module.alb[*].http_tcp_listener_arns[1]
}
output "target_group_blue" {
  value = local.ecs_destroy_trigger_flag == true ? null : module.alb[*].target_group_names[0]
}
output "target_group_green" {
  value = local.ecs_destroy_trigger_flag == true ? null : module.alb[*].target_group_names[1]
}
