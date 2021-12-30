output "name" {
  value = local.ecs_destroy_trigger_flag == true ? null : aws_codebuild_project.this[0].name
}