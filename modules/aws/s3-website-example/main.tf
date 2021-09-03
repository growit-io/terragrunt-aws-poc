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
