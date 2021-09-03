# aws-management-terraform-state

This module creates the required resources for
[Terraform S3 backend](https://www.terraform.io/docs/language/settings/backends/s3.html)
remote state configurations, and IAM policies for either read-only, or
read-write access.

The outputs of this module can be used to define a Terraform remote state
backend configuration, and are suitable for use as the virtual
["terragrunt" backend in `terragrunt.yml` files](../../../docs/terragrunt/README.md#the-remote_state-attribute).

The `aws` provider will be configured to use the current AWS credentials which
are expected to provide administrative access to the organization management
account.

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| aws | ~> 3.53.0 |

## Providers

No provider.

## Modules

| Name | Source | Version |
|------|--------|---------|
| terraform_remote_state | ../../aws/terraform-remote-state |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| default\_region | The default region in which to create S3 buckets for Terraform remote stat storage. This should normally an organization-wide default value provided via the `TF_VAR_default_region` environment variable. | `string` | n/a | yes |
| git\_repository | The value of the `GitRepository` tag for all resources created by this module. | `string` | n/a | yes |
| layer | The value of the `Layer` tag for all resources created by this module. | `string` | n/a | yes |
| organization | The value of the `Organization` tag for all resources created by this module. | `string` | n/a | yes |
| stage | The value of the `Stage` tag for all resources created by this module. | `string` | n/a | yes |
| terraform\_remote\_states | A map of objects describing the Terraform remote states to include in the outputs of this module. The S3 storage and IAM policies for these remote states will be created by this module, unless the `create` attribute is set to `false.<br><br>The objects in this map support the following attributes:<br><br>- **bucket** (string, default: generated randomly): Name of the S3 bucket that will store Terraform states.<br>- **create** (bool, default: `true`): Whether to create the S3 bucket and DynamoDB table, or not.<br>- **create_access_policies** (bool, default: `true`): Whether to create IAM read-only and read-write access policies.<br>- **dynamodb_table** (string, default: bucket name): Name of the DynamoDB table that will be used for locking Terraform states.<br>- **force_destroy** (bool, default: `false`): Value of the `force\_destroy` attribute for the created S3 bucket. You should set this to `true` and apply the configuration before removing any element from the map in order to destroy the S3 bucket. Alternatively, you can empty the corresponding S3 bucket manually, before removing an element from the map.<br>- **policy_name_prefix** (string, default: based on map key): A common prefix to prepend to each managed IAM policy name. Defaults to a CamelCase mutation of the map key.<br>- **policy_name_suffix** (string, default: `""`): A common suffix to append to each managed IAM policy name.<br>` | `any` | n/a | yes |
| tier | The value of the `Tier` tag for all resources created by this module. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| access\_policy\_arns | A mapping between the keys used in the `terraform_remote_states` input variable and objects describing the corresponding managed IAM policies. |
| terraform\_remote\_states | A mapping between the keys used in the `terraform_remote_states` input variable and objects describing the corresponding Terraform remote state backend. |

<!--- END_TF_DOCS --->
