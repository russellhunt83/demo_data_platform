resource "aws_ecs_cluster" "sftp_cluster" {
  name = "${var.environment_name}-mssql-cluster"
}

resource "aws_ecs_task_definition" "mssql" {
  family                   = "${var.environment_name}-mssql-server"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "mssql"
      image     = local.image_url
      cpu       = var.container_cpu
      memory    = var.container_memory
      essential = true
      portMappings = [
        {
          containerPort = 1433
          hostPort      = 1433
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "ACCEPT_EULA", value = "Y" },
        { name = "SA_PASSWORD", value = var.mssql_sa_password }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.environment_name}-mssql"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "mssql" {
  name            = "${var.environment_name}-mssql"
  cluster         = aws_ecs_cluster.sftp_cluster.id
  task_definition = aws_ecs_task_definition.mssql.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [data.aws_subnet.public_a.id, data.aws_subnet.public_b.id]
    security_groups  = [aws_security_group.mssql.id]
    assign_public_ip = true
  }
  depends_on = [aws_ecs_task_definition.mssql]
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment_name}-ecsTaskExecutionRole-mssql"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
}
