variable "aws_region" {
  description = "REQUIRED: AWS region to deploy resources"
  type        = string
}
variable "ecr_force_delete" {
  description = "OPTIONAL: Force delete ECR repository on destroy"
  type        = bool
  default     = true
}

variable "ecr_image_tag_mutability" {
  description = "OPTIONAL: ECR image tag mutability (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
}

variable "ecr_repo_name" {
  description = "REQUIRED: Name of the ECR repository"
  type        = string
}

variable "ecr_scan_on_push" {
  description = "OPTIONAL: Enable image scan on push for ECR"
  type        = bool
  default     = false
}

variable "ecr_lifecycle_retain_days" {
  description = "OPTIONAL: Number of days to retain images in ECR image"
  type        = number
  default     = 5
}

variable "project_name" {
  description = "REQUIRED: Name of the project for naming resources"
  type        = string
  
}