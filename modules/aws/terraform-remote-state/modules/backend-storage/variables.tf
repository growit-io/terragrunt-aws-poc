variable "bucket" {
  type        = string
  description = "The name of the S3 bucket to create."
}

variable "encrypt" {
  type        = bool
  default     = true
  description = "Whether to enable encryption on the created S3 bucket."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "A boolean that indicates all objects (including any locked objects) should be deleted from the bucket before destroying the bucket, so that the bucket can be destroyed without error. These objects are not recoverable."
}

variable "dynamodb_table" {
  type        = string
  description = "The DynamoDB table to create for storing locks of objects in the S3 bucket."
}
