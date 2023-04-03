variable "parent" {
  type = object({
    management_account_id    = string
    management_account_email = string

    organizational_unit = object({
      id = string
    })
  })

  description = "An object describing the parent of the organizational unit to create. This should be the outputs of either this module, or the [aws-management-organizations-root](../aws-management-organizations-root) module."
}

variable "name" {
  type        = string
  default     = ""
  description = "The name of the organizational unit to create. If empty, the name will be automatically generated based on the value of the `organization_unit` variable."
}

variable "organization_policies" {
  type = map(object({
    type        = string
    description = string
    content     = any
  }))

  default     = {}
  description = <<-EOT
    A map of objects describing organization policies to create and attach to the organizational unit.

    The map keys should be usable as Terraform resource names and the objects must have the following attributes:

    - **type** (string): The type of policy to create. For example, `SERVICE_CONTROL_POLICY`.
    - **description** (string): A description of the policy.
    - **content** (string): The policy document itself as an object suitable for [`jsonencode`](https://www.terraform.io/docs/language/functions/jsonencode.html).
  EOT
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

variable "organizational_unit" {
  type        = string
  description = "Used to construct the name of the organizational unit if the `name` variable is not given explicitly. This value should normally be provided automatically via the parent terragrunt.hcl file in this repository."
}

variable "git_repository" {
  type        = string
  description = "The value of the `GitRepository` tag for all resources created by this module."
}
