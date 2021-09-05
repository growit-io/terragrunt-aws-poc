variable "create" {
  type        = bool
  default     = true
  description = "Whether to actually manage the S3 bucket and DynamoDB table, or to only generate a backend configuration object based on the input variables."
}

variable "create_access_policies" {
  type        = bool
  default     = true
  description = "Whether to create customer managed IAM policies that govern access to the S3 bucket and DynamoDB table."
}

variable "bucket" {
  type        = string
  default     = ""
  description = "The name of the S3 bucket that stores the Terraform state. If unset or empty, a random name will be generated automatically."
}

variable "dynamodb_table" {
  type        = string
  default     = ""
  description = "The name of the DynamoDB table that will be used to lock objects in the S3 bucket. Defaults to the name of the bucket."
}

variable "encrypt" {
  type        = bool
  default     = true
  description = "Whether to enable server-side encryption on the S3 bucket (or to assume that it is enabled when `create` is `false`)."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "A boolean that indicates all objects (including any locked objects) should be deleted from the bucket before destroying the bucket, so that the bucket can be destroyed without error. These objects are not recoverable."
}

variable "policy_name_prefix" {
  type        = string
  default     = ""
  description = "A prefix to prepend to the names of all managed IAM policies."
}

variable "policy_name_suffix" {
  type        = string
  default     = ""
  description = "A suffix to append to the names of all managed IAM policies."
}

variable "policy_path" {
  type        = string
  default     = "/"
  description = "The IAM path under which to create the IAM policies."
}

variable "read_only_policy_name" {
  type        = string
  default     = "TerraformStateReadOnlyAccess"
  description = "The middle part of the name of the IAM policy which grants read-only access to the S3 bucket."
}

variable "read_write_policy_name" {
  type        = string
  default     = "TerraformStateReadWriteAccess"
  description = "The middle part of the name of the IAM policy which grants read-write access to the S3 bucket, and DynamoDB table."
}
