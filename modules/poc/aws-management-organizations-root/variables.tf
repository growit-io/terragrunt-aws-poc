variable "feature_set" {
  type = string
  default = "ALL"
  description = "Specify \"ALL\" (default) or \"CONSOLIDATED_BILLING\"."
}

variable "enabled_policy_types" {
  type = set(string)
  default = []
  description = <<-EOT
    List of Organizations policy types to enable in the Organization Root.
    Organization must have feature_set set to ALL. For additional information
    about valid policy types (e.g. AISERVICES_OPT_OUT_POLICY, BACKUP_POLICY,
    SERVICE_CONTROL_POLICY, and TAG_POLICY), see the AWS Organizations API
    Reference.
  EOT
}

variable "aws_service_access_principals" {
  type = set(string)
  default = []
  description = <<-EOT
    List of AWS service principal names for which you want to enable integration
    with your organization. This is typically in the form of a URL, such as
    service-abbreviation.amazonaws.com. Organization must have feature_set set
    to ALL. For additional information, see the AWS Organizations User Guide.
  EOT
}

variable "organization_policies" {
  type = any
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

variable "git_branch" {
  type = string
}

variable "git_commit" {
  type = string
}

variable "git_repository" {
  type = string
}
