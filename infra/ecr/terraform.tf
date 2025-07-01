terraform {
  backend "s3" {
    bucket = "demo-data-platform-terraform-state"
    key            = "ecr/terraform.tfstate"
    region         = "eu-west-1"
    #dynamodb_table = ""demo-data-platform-terraform-lock"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
  required_version = ">= 1.12.2"
}
