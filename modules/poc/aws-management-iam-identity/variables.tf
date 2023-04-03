variable "users" {
  type        = any
  default     = {}
  description = <<-EOT
    A map of objects describing the IAM users to create in the AWS Organizations management account.

    The map keys are the names of the IAM users to create and the values support the following attributes:

    - **access_key** (`bool`, default: `false`): Whether to create an access key for the user.
    - **groups** (`set(string)`, default: `[]`): The names of IAM groups which the user should be a member of. Each name must correspond to a map key in the `groups` variable.
    - **path** (`string`, default: `"/"`): The IAM path under which to create the user.
    - **pgp_key** (`string`, default: `null`): A base64-encoded PGP public key to encrypt the secret access key with. If a PGP key is specified, then the resulting access key will not be directly usable by other Terraform root modules and the secret key will be returned in the `encrypted_access_keys` output, instead of in the `plaintext_access_keys` output.
  EOT
}

variable "groups" {
  type        = set(string)
  description = "A set of names of IAM groups that are assumed to exist in the AWS Organizations management account."
}

variable "region" {
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
