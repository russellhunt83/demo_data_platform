resource "aws_ecs_cluster" "sftp_cluster" {
  name = "${var.environment_name}-sftp-cluster"
}

resource "aws_ecs_service" "sftp_service" {
  name            = "${var.environment_name}-sftp-service"
  cluster         = aws_ecs_cluster.sftp_cluster.id
  task_definition = aws_ecs_task_definition.sftp_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [data.aws_subnet.public_a.id, data.aws_subnet.public_b.id]
    security_groups  = [aws_security_group.sftp_sg.id]
    assign_public_ip = true
  }
  
  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_ecs_task_definition" "sftp_task" {
  family                   = "${var.environment_name}-sftp-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([
    {
      name      = "sftp"
      image     = local.image_url
      portMappings = [{
        containerPort = 22
        hostPort      = 22
        protocol      = "tcp"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.environment_name}-sftp"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
    
  ])
  
}