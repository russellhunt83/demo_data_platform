variable "aws_account_id" {
  description = "REQUIRED: AWS account ID for ECR repository"
  type        = string
  
}

variable "aws_region" {
  description = "REQUIRED: AWS region for log group"
  type        = string
}

variable "container_cpu" {
  description = "OPTIONAL: CPU units for the container"
  type        = number
  default     = 1024
}

variable "container_memory" {
  description = "OPTIONAL: Memory (MB) for the container"
  type        = number
  default     = 2048
}

variable "desired_count" {
  description = "OPTIONAL: Number of ECS tasks to run"
  type        = number
  default     = 1
}


variable "environment_name" {
  description = "REQUIRED: The environment name (e.g., dev, prod)"
  type        = string
}

variable "mssql_image" {
  description = "OPTIONAL: Docker image for MSSQL Server"
  type        = string
  default     = "mcr.microsoft.com/mssql/server:2022-latest"
}

variable "mssql_image_repository" {
  description = "REQUIRED: ECR repository name for MSSQL Server image"
  type        = string
  
}
variable "mssql_image_tag" {
  description = "OPTIONAL: Docker image tag for MSSQL Server"
  type        = string
  default     = "latest"
  
}

variable "mssql_sa_password" {
  description = "REQUIRED: SA password for MSSQL Server. Do not pass this in the tfVars file, use TF_VAR_mssql_sa_password"
  type        = string
  sensitive   = true
}

variable "owner" {
  description = "REQUIRED: Owner of the resources for tagging"
  type        = string
}

variable "project_name" {
  description = "REQUIRED: Project name for tagging resources"
  type        = string
  
}

variable "vpc_id" {
  description = "REQUIRED: VPC ID for ECS service"
  type        = string
}
