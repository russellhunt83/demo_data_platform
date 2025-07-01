locals {
  # Logical seperation of environment VPCs in this shared account. 
  # Alternatively I could have had dev and prod in different AWS accounts.
  vpc_name = "${var.environment_name}-${var.project_name}-vpc"
  public_subnet_a_name = "${var.environment_name}-${var.project_name}-public-a"
  public_subnet_b_name = "${var.environment_name}-${var.project_name}-public-b"
  private_subnet_a_name = "${var.environment_name}-${var.project_name}-private-a"
  private_subnet_b_name = "${var.environment_name}-${var.project_name}-private-b"
  igw_name = "${var.environment_name}-${var.project_name}-igw"
  nat_name = "${var.environment_name}-${var.project_name}-nat"
  public_rt_name = "${var.environment_name}-${var.project_name}-public-rt"
  private_rt_name = "${var.environment_name}-${var.project_name}-private-rt"
}
