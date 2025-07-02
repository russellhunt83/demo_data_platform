locals {
   public_subnet_a = "${var.environment_name}-${var.project_name}-public-a"
   public_subnet_b = "${var.environment_name}-${var.project_name}-public-b"
   image_url = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.mssql_image_repository}:mssql.${var.mssql_image_tag}"
}