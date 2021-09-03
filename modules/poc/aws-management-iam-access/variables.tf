variable "groups" {
  type = map(object({
    path     = string
    policies = set(string)
  }))

  default = {}
}

variable "policies" {
  type    = any
  default = {}
}

variable "policy_arns" {
  type    = map(string)
  default = {}
}

variable "terraform_remote_state_backend" {
  type = string

  validation {
    condition     = var.terraform_remote_state_backend == "s3"
    error_message = "This root module only supports the S3 backend, for now."
  }
}

variable "terraform_remote_state_config" {
  type = object({
    region         = string
    bucket         = string
    encrypt        = bool
    dynamodb_table = string
    key            = string
  })
}

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

variable "stack" {
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
