resource "aws_ecr_repository" "sftp_repo" {
  name                 = local.ecr_repository_name
  image_tag_mutability = var.ecr_image_tag_mutability
  force_delete         = var.ecr_force_delete
  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push
  }
}

resource "aws_ecr_lifecycle_policy" "sftp_repo_policy" {
  repository = aws_ecr_repository.sftp_repo.name
  policy     = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep only last ${var.ecr_lifecycle_retain_days} images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": ${var.ecr_lifecycle_retain_days}
      },
      "action": { "type": "expire" }
    }
  ]
}
EOF
}
