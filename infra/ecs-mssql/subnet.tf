#This is a demonstration of Semi Structured data files
# Files can be provided by 3rd party providers who don't have AWS accounts to peer, or create service endpoints for.
data "aws_subnet" "public_a" {
  filter {
    name   = "tag:Name"
    values = [local.public_subnet_a]
  }
}

data "aws_subnet" "public_b" {
  filter {
    name   = "tag:Name"
    values = [local.public_subnet_b]
  }
}