variable "region" {
  type = string
  default = ""
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

variable "account" {
  type = object({
    id = string
    name = string
    role_arns = object({
      WebsiteAdministrator = string
    })
  })
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
