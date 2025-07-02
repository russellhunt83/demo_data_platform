resource "aws_lakeformation_data_lake_settings" "main" {
  admins = [data.aws_caller_identity.current.arn, aws_iam_role.lakeformation_admin.arn]

  create_database_default_permissions {
    permissions = ["ALL"]
    principal   = "IAM_ALLOWED_PRINCIPALS"
  }

  create_table_default_permissions {
    permissions = ["ALL"]
    principal   = "IAM_ALLOWED_PRINCIPALS"
  }
}

resource "aws_lakeformation_resource" "datalake_bucket" {
  arn        = aws_s3_bucket.datalake.arn
  role_arn   = aws_iam_role.datalake_s3_manager.arn
  depends_on = [aws_lakeformation_data_lake_settings.main]
}

resource "aws_glue_catalog_database" "datalake" {
  name         = lower("${local.glue_database_name}_inbound")
  location_uri = "s3://${aws_s3_bucket.datalake.bucket}/inbound/"
}

resource "aws_glue_catalog_table" "person" {
  name          = "person"
  database_name = aws_glue_catalog_database.datalake.name
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    "classification" = "csv"
    "EXTERNAL"        = "TRUE"
  }
  storage_descriptor {
    location      = "s3://${aws_s3_bucket.datalake.bucket}/inbound/person/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    }
}
