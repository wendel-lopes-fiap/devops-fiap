resource "aws_ecs_cluster" "cluster" {
  name = "ecs-cluster-mvp"
}

resource "aws_cloudwatch_log_group" "ecs_my_application_log_group" {
  name              = "/ecs/my-application"
  retention_in_days = 30
}