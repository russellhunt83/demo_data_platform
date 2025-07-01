provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "DemoDataPlatform"
      Environment = "dev"
      Owner       = "russellhunt"
    }
  }
}
