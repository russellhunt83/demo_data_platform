terraform {
  backend "s3" {
    bucket = "demo-data-platform-terraform-state"
    key            = "glue/terraform.tfstate"
    region         = "eu-west-1"
    #dynamodb_table = "my-lock-table"
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
