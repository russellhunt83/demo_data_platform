resource "aws_s3_bucket" "datalake" {
  bucket        = local.s3_bucket_name
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.datalake.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_object" "inbound_prefix" {
  bucket = aws_s3_bucket.datalake.id
  key    = "inbound/"
  acl    = "private"
}

