variable "aws_region" {
  description = "REQUIRED: AWS region for Glue resources"
  type        = string
}

variable "environment_name" {
  description = "REQUIRED: The environment name (e.g., dev, prod)"
  type        = string
}

variable "glue_db_name" {
  description = "OPTIONAL: Name for the Glue database"
  type        = string
  default     = "demodataplatform"
}

variable "owner" {
  description = "REQUIRED: Owner of the resources for tagging"
  type        = string
  
}

variable "project_name" {
  description = "REQUIRED: Project name for tagging"
  type        = string
}

