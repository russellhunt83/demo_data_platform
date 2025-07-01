variable "aws_region" {
  description = "REQUIRED: AWS region to deploy resources"
  type        = string
}

variable "aws_account_id" {
  description = "REQUIRED: AWS account ID for ECR image URL"
  type        = string
  
}

variable "environment_name" {
  description = "REQUIRED: Name of the environment [dev|prod])"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], lower(var.environment_name))
    error_message = "environment_name must be either 'dev' or 'prod' (case-insensitive)."
  }
}
variable "owner" {
  description = "REQUIRED: Owner of the resources for tagging"
  type        = string
  
}

variable "project_name" {
  description = "REQUIRED: Project name for tagging"
  type        = string
}


variable "sftp_image_repository" {
  description = "REQUIRED: Docker image for SFTP container (ECR URI)"
  type        = string
}

variable "sftp_image_tag" {
  description = "OPTIONAL: Docker image tag for SFTP container"
  type        = string
  default     = "latest"
}

variable "sftp_users" {
  description = "OPTIONAL: SFTP users string for atmoz/sftp (e.g. 'sftpuser:::upload:')"
  type        = string
  default     = "sftpuser::::upload" #@TODO: Move this to SSM
}

variable "vpc_id" {
  description = "REQUIRED: An existing VPC ID for ECS and security group"
  type        = string
}