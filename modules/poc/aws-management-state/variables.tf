variable "organization" {
  type = string
}

variable "tier" {
  type = string
}

variable "stage" {
  type = string
}

variable "layer" {
  type = string
}

variable "git_branch" {
  type = string
}

variable "git_commit" {
  type = string
}

variable "git_repository" {
  type = string
}

variable "default_region" {
  type = string
}

variable "terraform_remote_state_backend" {
  type = string

  validation {
    condition = var.terraform_remote_state_backend == "s3"
    error_message = "This root module only supports the S3 backend, for now."
  }
}

variable "terraform_remote_state_config" {
  type = object({
    region = string
    bucket = string
    encrypt = bool
    dynamodb_table = string
  })
}

variable "terraform_remote_states" {
  type = any

  validation {
    condition = length(setsubtract(toset(keys(merge(values(var.terraform_remote_states)...))), toset([
      "bucket",
      "create",
      "create_access_policies",
      "dynamodb_table",
      "force_destroy",
      "policy_name_prefix",
      "policy_name_suffix",
    ]))) == 0

    error_message = "One or more keys in terraform_remote_state are not valid."
  }
}
