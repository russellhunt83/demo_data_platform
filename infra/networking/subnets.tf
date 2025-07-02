resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.dataplatform_vpc.id 
  cidr_block              = var.public_a_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = local.public_subnet_a_name
  }

}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.dataplatform_vpc.id 
  cidr_block              = var.public_b_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = local.public_subnet_b_name
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.dataplatform_vpc.id 
  cidr_block        = var.private_a_cidr
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = local.private_subnet_a_name
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.dataplatform_vpc.id  
  cidr_block        = var.private_b_cidr
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = local.private_subnet_b_name
  }
}

resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.dataplatform_vpc.id  
  tags = { Name = local.igw_name }
}

resource "aws_eip" "nat_eip" {}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id
  tags = { Name = local.nat_name }
}

resource "aws_route_table" "ecs_public_rt" {
  vpc_id = aws_vpc.dataplatform_vpc.id 
  tags = { Name = local.public_rt_name }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.ecs_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_igw.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.ecs_public_rt.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.ecs_public_rt.id
}

resource "aws_route_table" "ecs_private_rt" {
  vpc_id = aws_vpc.dataplatform_vpc.id 
}

resource "aws_route" "private_nat_egress" {
  route_table_id         = aws_route_table.ecs_private_rt.id
  destination_cidr_block = "0.0.0.0/0" #Allows internet connected resources in the private subnet to reach anywhere on the Inernet. Enterprise solutions may want to limit this to for example 443 only.
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.ecs_private_rt.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.ecs_private_rt.id
}