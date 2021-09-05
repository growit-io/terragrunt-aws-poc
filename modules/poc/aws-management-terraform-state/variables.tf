variable "terraform_remote_states" {
  type = any

  validation {
    condition = length(setsubtract(toset(keys(merge(values(var.terraform_remote_states)...))), toset([
      "bucket",
      "create",
      "create_access_policies",
      "dynamodb_table",
      "force_destroy",
      "policy_name_prefix",
      "policy_name_suffix",
    ]))) == 0

    error_message = "One or more keys in terraform_remote_state are not valid."
  }

  description = <<-EOT
    A map of objects describing the Terraform remote states to include in the outputs of this module. The S3 storage and IAM policies for these remote states will be created by this module, unless the `create` attribute is set to `false.

    The objects in this map support the following attributes:

    - **bucket** (string, default: generated randomly): Name of the S3 bucket that will store Terraform states.
    - **create** (bool, default: `true`): Whether to create the S3 bucket and DynamoDB table, or not.
    - **create_access_policies** (bool, default: `true`): Whether to create IAM read-only and read-write access policies.
    - **dynamodb_table** (string, default: bucket name): Name of the DynamoDB table that will be used for locking Terraform states.
    - **force_destroy** (bool, default: `false`): Value of the `force_destroy` attribute for the created S3 bucket. You should set this to `true` and apply the configuration before removing any element from the map in order to destroy the S3 bucket. Alternatively, you can empty the corresponding S3 bucket manually, before removing an element from the map.
    - **policy_name_prefix** (string, default: based on map key): A common prefix to prepend to each managed IAM policy name. Defaults to a CamelCase mutation of the map key.
    - **policy_name_suffix** (string, default: `""`): A common suffix to append to each managed IAM policy name.
  EOT
}

variable "region" {
  type        = string
  description = "The region in which to create S3 buckets for Terraform remote state storage."
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

variable "git_repository" {
  type        = string
  description = "The value of the `GitRepository` tag for all resources created by this module."
}
