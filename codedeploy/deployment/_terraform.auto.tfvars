env   = "dev"
name  = "dev"
owner = "dj.kim"
tags  = {}

# iam
trusted_role_services = ["codedeploy.amazonaws.com"]
custom_role_policy_arns = [
  "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS",
  "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
]

# codedeploy
compute_platform = "ECS"
// ec2_tag_filter = [
//   {
//     key   = "Name"
//     type  = "KEY_AND_VALUE"
//     value = "target-ec2" # target-1-ec2, target-2-ec2, ...
//   }
// ]