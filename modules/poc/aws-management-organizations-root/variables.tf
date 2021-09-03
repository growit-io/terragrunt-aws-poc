variable "feature_set" {
  type        = string
  default     = "ALL"
  description = "Specify \"ALL\" (default) or \"CONSOLIDATED_BILLING\"."
}

variable "enabled_policy_types" {
  type        = set(string)
  default     = []
  description = <<-EOT
    List of Organizations policy types to enable in the Organization Root.
    Organization must have feature_set set to ALL. For additional information
    about valid policy types (e.g. AISERVICES_OPT_OUT_POLICY, BACKUP_POLICY,
    SERVICE_CONTROL_POLICY, and TAG_POLICY), see the AWS Organizations API
    Reference.
  EOT
}

variable "aws_service_access_principals" {
  type        = set(string)
  default     = []
  description = <<-EOT
    List of AWS service principal names for which you want to enable integration
    with your organization. This is typically in the form of a URL, such as
    service-abbreviation.amazonaws.com. Organization must have feature_set set
    to ALL. For additional information, see the AWS Organizations User Guide.
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
    A map of objects describing organization policies to create and attach to the organization at the root level.

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
