

resource "aws_kms_key" "datalake" {
  description             = "KMS key for encrypting datalake bucket"
  deletion_window_in_days = var.kms_key_deletion_window_days
  enable_key_rotation     = true
  
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid       = "Allow administration of the key to the account root and current user"
        Effect    = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
            data.aws_caller_identity.current.arn
          ]
        }
        Action    = [
          "kms:*"
        ]
        Resource  = "*"
      },
      {
        Sid      = "Allow use of the key for S3 encryption/decryption to current user"
        Effect   = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.arn
        }
        Action   = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "datalake" {
  name          = local.kms_key_alias
  target_key_id = aws_kms_key.datalake.key_id

}