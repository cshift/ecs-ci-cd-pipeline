resource "aws_codedeploy_app" "this" {
  count            = local.ecs_destroy_trigger_flag == true || local.deployment_controller == "ECS" ? 0 : 1
  compute_platform = local.compute_platform
  name             = local.app_name

  tags = merge(local.cd_app_tags, { Name = local.app_name })
}

resource "aws_codedeploy_deployment_group" "this" {
  count                  = local.ecs_destroy_trigger_flag == true || local.deployment_controller == "ECS" ? 0 : 1
  app_name               = local.app_name
  deployment_group_name  = local.deployment_group_name
  deployment_config_name = local.deployment_config_name
  service_role_arn       = module.iam[2].iam_role_arn
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }
  }
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = local.ecs_cluster_id
    service_name = local.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [local.listener_arns_blue]
      }
      target_group {
        name = local.target_group_blue
      }
      target_group {
        name = local.target_group_green
      }
      test_traffic_route {
        listener_arns = [local.listener_arns_green]
      }
    }
  }


  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  #  alarm_configuration {
  #    alarms  = ["my-alarm-name"]
  #    enabled = true
  #  }

  tags = merge(local.cd_group_tags, { Name = local.deployment_group_name })
}