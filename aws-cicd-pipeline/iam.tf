# iam
module "iam" {
  count                   = local.ecs_destroy_trigger_flag == true ? 0 : 3
  source                  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version                 = "~> 4.3"
  create_role             = true
  create_instance_profile = true
  role_name               = local.role_name[count.index]
  role_requires_mfa       = false
  trusted_role_services   = local.trusted_role_services[count.index]
  custom_role_policy_arns = local.custom_role_policy_arns[count.index]
}
