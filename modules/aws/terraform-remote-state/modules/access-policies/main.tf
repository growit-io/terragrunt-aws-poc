terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.53.0"
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  account_id         = data.aws_caller_identity.current.account_id
  dynamodb_table_arn = "arn:aws:dynamodb:${var.region}:${local.account_id}:table/${var.dynamodb_table}"
  s3_bucket_arn      = "arn:aws:s3:::${var.bucket}"
}

resource "aws_iam_policy" "read_only" {
  name        = "${var.name_prefix}${var.read_only_name}${var.name_suffix}"
  path        = var.path
  description = "Grants read-only access to the Terraform state S3 bucket ${var.bucket} and DynamoDB lock table ${var.dynamodb_table}."

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem"
        ]

        Resource = local.dynamodb_table_arn
      },
      {
        Effect   = "Allow"
        Action   = "s3:ListAllMyBuckets"
        Resource = "*"
      },
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning"
        ]

        Resource = local.s3_bucket_arn
      },
      {
        Effect = "Allow"
        Action = "s3:GetObject"

        Resource = [
          "${local.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "read_write" {
  name        = "${var.name_prefix}${var.read_write_name}${var.name_suffix}"
  path        = var.path
  description = "Grants read-write access to the Terraform state S3 bucket ${var.bucket} and DynamoDB lock table ${var.dynamodb_table}."

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem"
        ]

        Resource = local.dynamodb_table_arn
      },
      {
        Effect   = "Allow"
        Action   = "s3:ListAllMyBuckets"
        Resource = "*"
      },
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning"
        ]

        Resource = local.s3_bucket_arn
      },
      {
        Effect = "Allow"

        Action = [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = [
          "${local.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}
