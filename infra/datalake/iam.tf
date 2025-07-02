resource "aws_iam_role" "lakeformation_admin" {
  name = "${var.environment_name}-datalake-formation-admin"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lakeformation.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lakeformation_admin_policy" {
  role       = aws_iam_role.lakeformation_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLakeFormationDataAdmin"
}

resource "aws_iam_role" "datalake_s3_manager" {
  name = "${var.environment_name}-datalake-s3-manager"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "*",
          Service = "lakeformation.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "datalake_s3_kms_access" {
  name   = "${var.environment_name}-datalake-s3-kms-access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          aws_s3_bucket.datalake.arn,
          "${aws_s3_bucket.datalake.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = [aws_kms_key.datalake.arn]
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "datalake_secure" {
  bucket = aws_s3_bucket.datalake.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "DenyUnEncryptedConnection"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.datalake.arn,
          "${aws_s3_bucket.datalake.arn}/*"
        ]
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      },
      {
        Sid = "DenyUnsecureDownloads",
        Effect = "Deny"
        Principal = "*"
        Action = ["s3:GetObject", "s3:GetObjectVersion", "s3:GetObjectAcl"]
        Resource = "${aws_s3_bucket.datalake.arn}/*"
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      },
      {
        Sid = "DenyUnsecureUploads",
        Effect = "Deny"
        Principal = "*"
        Action = ["s3:PutObject", "s3:PutObjectAcl"]
        Resource = "${aws_s3_bucket.datalake.arn}/*"
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      },
      {
        Sid = "AllowIAMUserAccess",
        Effect = "Allow",
        Principal = { "AWS": [data.aws_caller_identity.current.arn] },
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.datalake.arn,
          "${aws_s3_bucket.datalake.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "datalake_s3_manager_access" {
  role       = aws_iam_role.datalake_s3_manager.name
  policy_arn = aws_iam_policy.datalake_s3_kms_access.arn
}

resource "aws_iam_user" "lakeformation_user" {
  name = "${var.environment_name}-datalake-user"
  force_destroy = true

}

resource "aws_iam_user_login_profile" "lakeformation_user_console" {
  #This would be stored in SSM for example. 
  user    = aws_iam_user.lakeformation_user.name
  pgp_key = null 
  password_reset_required = true 
}

resource "aws_iam_user_policy_attachment" "lakeformation_user_lakeformation_admin" {
  user       = aws_iam_user.lakeformation_user.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLakeFormationDataAdmin"
}

resource "aws_iam_user_policy_attachment" "lakeformation_user_s3_kms_access" {
  user       = aws_iam_user.lakeformation_user.name
  policy_arn = aws_iam_policy.datalake_s3_kms_access.arn
}
