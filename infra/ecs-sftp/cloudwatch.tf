resource "aws_cloudwatch_log_group" "mssql" {
  name              = "/ecs/${var.environment_name}-sftp"
  retention_in_days = 7
}