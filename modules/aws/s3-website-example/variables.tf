variable "organization" {
  type        = string
  description = "An identifier for the organization to which the S3 example website belongs. This will be used as a component in the name of the S3 bucket created."
}

variable "stage" {
  type        = string
  description = "An identifier for the development stage to which the S3 example website belongs. This will be used as a component in the name of the S3 bucket created."
}
