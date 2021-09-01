resource "aws_s3_bucket" "this" {
  bucket = var.bucket

  acl = "private"
  force_destroy = var.force_destroy

  versioning {
    enabled = true
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.encrypt ? [true] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "aws:kms"
        }
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.bucket

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "this" {
  name = var.dynamodb_table

  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
