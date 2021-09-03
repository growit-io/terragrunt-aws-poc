variable "groups" {
  type = map(any)

  default     = {}
  description = <<-EOT
    A map of objects describing the IAM groups to create in the AWS Organization management account.

    The map keys are the names of the IAM groups and the map values require the following attributes:

    - **path** (`string`): IAM path under which to create the group.
    - **policies** (`set(string)`): The names or ARNs of IAM policies to attach to the group. When IAM policy names are given instead of ARNs, the names must correspond to a map key in either the `policies`, or the `policy_arns` input variable.
  EOT
}

variable "policies" {
  type        = map(any)
  default     = {}
  description = <<-EOT
    A map of objects describing managed IAM policies to create in the AWS Organizations management account. The names of these managed IAM policies are automatically available for reference in the `groups` input variable.

    The map keys correspond to the IAM policy names and the map values support the following attributes:

    - **description** (`string`): Description of the IAM policy.
    - **path** (`string`, default: `"/"`): IAM path under which to create the policy.
    - **policy** (`string`): IAM policy document object suitable for [`jsonencode`](https://www.terraform.io/docs/language/functions/jsonencode.html).
  EOT
}

variable "policy_arns" {
  type        = map(string)
  default     = {}
  description = "A map of IAM policy names and corresponding ARNs that will be available for referencing in the `groups` variable."
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
