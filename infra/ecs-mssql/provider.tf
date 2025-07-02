provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment =  var.environment_name
      Owner       = var.owner
    }
  }
}
