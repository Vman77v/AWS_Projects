resource "aws_s3_bucket" "archive_bucket" {
  bucket = "fsa.archive.${var.app_env}"
  acl    = "private"
  tags = local.common_tags

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}