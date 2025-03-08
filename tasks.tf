resource "aws_ecs_task_definition" "my_application" {
  family                   = "my-application"
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "my-application-container",
      image = "nginx:latest",
      #   image        = aws_ecr_repository.application_repository.repository_url,
      cpu          = 256,
      memory       = 512,
      essential    = true,
      portMappings = [{ containerPort = 80, hostPort = 80 }],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_my_application_log_group.name,
          "awslogs-region"        = "us-east-1",
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "my_application_service" {
  name            = "my-application-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.my_application.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1b.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    container_name   = "my-application-container"
    container_port   = 80
  }

  depends_on = [
    aws_ecs_cluster.cluster,
    aws_ecr_repository.application_repository,
    aws_lb.my_load_balancer,
  ]
}
