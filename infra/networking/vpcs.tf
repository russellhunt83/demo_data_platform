resource "aws_vpc" "dataplatform_vpc" {
  cidr_block           = var.vpc_range
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = local.vpc_name
  }
}