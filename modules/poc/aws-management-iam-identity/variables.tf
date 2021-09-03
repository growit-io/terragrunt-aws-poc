variable "users" {
  type = map(object({
    access_key = bool
    groups     = set(string)
    path       = string
    pgp_key    = string
  }))

  default     = {}
  description = "A map of objects describing the IAM users to create in the AWS Organizations management account."
}

variable "groups" {
  type        = set(string)
  description = "A set of names of IAM groups to create in the AWS Organizations management account."
}

variable "default_region" {
  type        = string
  description = "The region to configure for the default `aws` provider in this module."
}

variable "organization" {
  type        = string
  description = "The value of the `Organization` tag for all resources created by this module."
}

variable "tier" {
  type        = string
  description = "The value of the `Tier` tag for all resources created by this module."
}

variable "stage" {
  type        = string
  description = "The value of the `Stage` tag for all resources created by this module."
}

variable "layer" {
  type        = string
  description = "The value of the `Layer` tag for all resources created by this module."
}

variable "stack" {
  type        = string
  description = "The value of the `Stack` tag for all resources created by this module."
}

variable "git_repository" {
  type        = string
  description = "The value of the `GitRepository` tag for all resources created by this module."
}
