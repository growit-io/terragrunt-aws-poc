variable "users" {
  type = map(object({
    access_key = bool
    groups     = set(string)
    path       = string
    pgp_key    = string
  }))

  default = {}
}

variable "groups" {
  type = set(string)
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

variable "git_branch" {
  type = string
}

variable "git_commit" {
  type = string
}

variable "git_repository" {
  type = string
}
