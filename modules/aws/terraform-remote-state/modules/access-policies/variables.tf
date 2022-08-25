variable "name_prefix" {
  type        = string
  description = "A prefix to prepend to the names of all managed IAM policies."
}

variable "read_only_name" {
  type        = string
  description = "The middle part of the name of the IAM policy which grants read-only access to the S3 bucket."
}

variable "read_write_name" {
  type        = string
  description = "The middle part of the name of the IAM policy which grants read-write access to the S3 bucket, and DynamoDB table."
}

variable "name_suffix" {
  type        = string
  description = "A suffix to append to the names of all managed IAM policies."
}

variable "path" {
  type        = string
  description = "The IAM path under which to create the IAM policies."
}

variable "region" {
  type        = string
  description = "The region in which the S3 bucket was created."
}

variable "bucket" {
  type        = string
  description = "The name of an S3 bucket used as Terraform state storage."
}

# TODO: configure additional policy constraints based on the `encrypt` variable
#variable "encrypt" {
#  type       = bool
#  description = "Whether the S3 bucket requires encrypted objects, or not."
#}

variable "dynamodb_table" {
  type        = string
  description = "The name of a DynamoDB table used for locking objects in the S3 bucket."
}
