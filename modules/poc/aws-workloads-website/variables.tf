variable "account" {
  type = object({
    name = string
    role_arns = object({
      WebsiteAdministrator = string
    })
  })

  description = <<EOT
    An object describing the AWS account in which the S3 website should be deployed. This should normally be the outputs of the [aws-management-organizations-account](../aws-management-organizations-account/README.md) module.

    Specifically, this module expects an output named `role_arns.WebsiteAdministrator`, whose value will be passed to the `role_arn` attribute of the default `aws` provider.

    The `name` attribute of this object is used as the value of the `Acount` tag for all resources created by this module.
  EOT
}

variable "region" {
  type        = string
  default     = ""
  description = "The region in which to deploy the website. Defaults to the value of the `default_region` variable."
}

variable "default_region" {
  type        = string
  description = "The default region in which to deploy the website, if no value is provided for the `region` variable. This should normally be an organization-wide default value provided via the `TF_VAR_default_region` environment variable."
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
