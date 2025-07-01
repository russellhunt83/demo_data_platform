variable "aws_region" {
  description = "REQUIRED: AWS region for the resources"
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

variable "private_a_cidr" {
  description = "OPTIONAL: CIDR block for private subnet A"
  type        = string
  default     = "10.0.2.0/24" # Evenly divided CIDR for private subnet A

}

variable "private_b_cidr" {
  description = "OPTIONAL: CIDR block for private subnet B"
  type        = string
  default     = "10.0.3.0/24" # Evenly divided CIDR for Private subnet B
}

variable "project_name" {
  description = "REQUIRED: Project name for tagging"
  type        = string
}

variable "public_a_cidr" {
  description = "OPTIONAL: CIDR block for public subnet A"
  type        = string
  default     = "10.0.0.0/24" # Evenly divided CIDR for public subnet A
}

variable "public_b_cidr" {
  description = "OPTIONAL: CIDR block for public subnet B"
  type        = string
  default     = "10.0.1.0/24" # Evenly divided CIDR for public subnet B
}

variable "vpc_range" {
  description = "OPTIONAL: CIDR range for the VPC"
  type        = string
  default     = "10.0.0.0/22" # Default CIDR of 1024 IP Addresses for a Medium sized VPC
  
}