module "iam" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4.3"

  create_role             = true
  create_instance_profile = true
  role_name               = local.role_name
  role_requires_mfa       = false

  trusted_role_services   = local.trusted_role_services
  custom_role_policy_arns = local.custom_role_policy_arns
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name              = local.app_name
  deployment_group_name = local.deployment_group_name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = module.iam.iam_role_arn
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

  tags = merge(local.tags, { Name = local.deployment_group_name })
}
