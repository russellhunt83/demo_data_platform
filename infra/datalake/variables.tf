variable "environment_name" {
  description = "REQUIRED: The environment name (e.g., dev, prod)"
  type        = string
}

variable "aws_region" {
  description = "REQUIRED: AWS region for Lake Formation resources"
  type        = string
}

variable "kms_key_deletion_window_days" {
  description = "OPTIONAL: KMS key deletion window in days"
  type        = number
  default     = 7
  
}


variable "owner" {
  description = "REQUIRED: Owner of the resources for tagging"
  type        = string
  
}

variable "project_name" {
  description = "REQUIRED: Project name for tagging"
  type        = string
  
}