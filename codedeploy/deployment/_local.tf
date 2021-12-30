locals {
  region = var.region

  role_name              = format("%s-codedeploy-role", var.name)
  deployment_config_name = format("%s-codedeploy-config", var.name)
  deployment_group_name  = format("%s-codedeploy-group", var.name)

  tags = merge(var.tags, { Owner = var.owner, Environment = var.env })

  # iam
  trusted_role_services   = var.trusted_role_services
  custom_role_policy_arns = var.custom_role_policy_arns

  # codedeploy
  // ec2_tag_filter   = var.ec2_tag_filter
  compute_platform = var.compute_platform

  # codedeployapp
  app_name = data.terraform_remote_state.app.outputs.name

  ecs_cluster_id = data.terraform_remote_state.ecs.outputs.ecs_cluster_id[0]
  ecs_service_name = data.terraform_remote_state.ecs.outputs.ecs_service_name[0]
  alb_target_group_arns = data.terraform_remote_state.ecs.outputs.alb_target_group_arns[0]
  listener_arns = data.terraform_remote_state.ecs.outputs.listener_arns[0]
  target_group_names = data.terraform_remote_state.ecs.outputs.target_group_names[0]
  listener_arns_blue = data.terraform_remote_state.ecs.outputs.listener_arns_blue[0]
  listener_arns_green = data.terraform_remote_state.ecs.outputs.listener_arns_green[0]
  target_group_blue = data.terraform_remote_state.ecs.outputs.target_group_blue[0]
  target_group_green = data.terraform_remote_state.ecs.outputs.target_group_green[0]

}