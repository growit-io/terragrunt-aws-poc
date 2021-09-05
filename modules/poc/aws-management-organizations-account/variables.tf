variable "parent" {
  type = object({
    management_account_email = string

    organizational_unit = object({
      id = string
    })
  })

  description = "An object describing the parent of the AWS Organizations member account to create. This should be the outputs of either the [aws-management-organizations-unit](../aws-management-organizations-unit), or the [aws-management-organizations-root](../aws-management-organizations-root) module."
}

# TODO: rename the `account` variable to `name`
variable "account" {
  type        = string
  description = "The name of the AWS Organizations member account to create."
}

variable "email_separator" {
  type        = string
  default     = "+"
  description = "The separator string to expect in the management account email address, and to use when constructing the email address of the member account's root user."
}

variable "email" {
  type        = string
  default     = ""
  description = "An explicit email address to use for the root user of the member account. If unset, this will be generated automatically based on the management account's root user email address, and the member account name."
}

variable "roles" {
  type        = map(any)
  default     = {}
  description = <<-EOT
    A map of objects describing IAM roles to create in the member account. The
    exclusive trusted principal of each role will be the AWS Organizations
    management account.

    Map keys should be CamelCase role names. The suffix `Role` will be automatically appended to each name by this module.

    Map values support the following attributes:

    - **description** (`string`): A description of the role.
    - **path** (`string`, default: `"/"`): The IAM path under which to create the role.
    - **inline_policies** (`set(object({name = string, policy=any}))`): A set of IAM policies to define as inline policies for the role. The `policy` attribute should be an IAM policy document object suitable for [`jsonencode`](https://www.terraform.io/docs/language/functions/jsonencode.html).
  EOT
}

variable "organization_policies" {
  type = map(object({
    type        = string
    description = string
    content     = any
  }))

  default     = {}
  description = <<-EOT
    A map of objects describing organization policies to create and attach to the organization member account.

    The map keys should be usable as Terraform resource names and the objects must have the following attributes:

    - **type** (string): The type of policy to create. For example, `SERVICE_CONTROL_POLICY`.
    - **description** (string): A description of the policy.
    - **content** (string): The policy document itself as an object suitable for the [jsonencode](https://www.terraform.io/docs/language/functions/jsonencode.html) function.
  EOT
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
