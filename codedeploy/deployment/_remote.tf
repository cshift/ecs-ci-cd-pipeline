
// data "terraform_remote_state" "app" {
//   backend = "s3"
//   config = {
//     bucket = var.backend_s3
//     key    = var.codedeploy_app_key
//     region = var.region
//   }
// }

// data "terraform_remote_state" "ecs" {
//   backend = "s3"
//   config = {
//     bucket = var.backend_s3
//     key    = var.ecs_key
//     region = var.region
//   }
// }