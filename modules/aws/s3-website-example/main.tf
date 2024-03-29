terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.53.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }
}
locals {
  index_document = "${path.module}/files/index.html"
  error_document = "${path.module}/files/error.html"
}

resource "random_id" "this" {
  byte_length = 4
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.organization}-${var.stage}-${random_id.this.hex}"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false

      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  force_destroy = true
}

resource "aws_s3_bucket_object" "index_document" {
  bucket = aws_s3_bucket.this.bucket
  key    = aws_s3_bucket.this.website[0].index_document
  source = local.index_document
  etag   = filemd5(local.index_document)
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "error_document" {
  bucket = aws_s3_bucket.this.bucket
  key    = aws_s3_bucket.this.website[0].error_document
  source = local.error_document
  etag   = filemd5(local.error_document)
  acl    = "public-read"
}
