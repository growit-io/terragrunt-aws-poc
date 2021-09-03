variable "name" {
  type    = string
  default = ""
}

variable "parent" {
  type = object({
    management_account_id    = string
    management_account_email = string

    organizational_unit = object({
      id = string
    })
  })
}

variable "organization_policies" {
  type    = any
  default = {}
}

variable "default_region" {
  type = string
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

variable "organizational_unit" {
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
