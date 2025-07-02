locals {
    kms_key_alias = "alias/${var.environment_name}-${var.project_name}-S3bucket-key"
    lake_formation_admin_arn = data.aws_caller_identity.current.arn
    glue_database_name = lower("${var.environment_name}_${var.project_name}")
    s3_bucket_name = lower("${var.environment_name}-${var.project_name}-datalake")
}