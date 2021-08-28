variable "cloud" {
  type = string

  validation {
    condition = var.cloud == "examples"
    error_message = "The value should match the name of the first subdirectory that leads to this module, under the root directory of the repository. The expected name for this directory is \"examples\"."
  }
}

variable "example" {
  type = string

  validation {
    condition = var.example == "hello-world"
    error_message = "The value should match the name of the directory in which this variables.tf file is located."
  }
}

variable "hello" {
  type = string

  validation {
    condition = var.hello == "world"
    error_message = "The value is expected to be set to \"world\", somewhere in one of the terragrunt.yml files in the parent directory hierarchy."
  }
}
