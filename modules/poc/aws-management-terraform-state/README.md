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

<!-- BEGIN_TF_DOCS -->


## Required Inputs

The following input variables are required:

### <a name="input_git_repository"></a> [git\_repository](#input\_git\_repository)

Description: The value of the `GitRepository` tag for all resources created by this module.

Type: `string`

### <a name="input_layer"></a> [layer](#input\_layer)

Description: The value of the `Layer` tag for all resources created by this module.

Type: `string`

### <a name="input_organization"></a> [organization](#input\_organization)

Description: The value of the `Organization` tag for all resources created by this module.

Type: `string`

### <a name="input_region"></a> [region](#input\_region)

Description: The region in which to create S3 buckets for Terraform remote state storage.

Type: `string`

### <a name="input_stage"></a> [stage](#input\_stage)

Description: The value of the `Stage` tag for all resources created by this module.

Type: `string`

### <a name="input_terraform_remote_states"></a> [terraform\_remote\_states](#input\_terraform\_remote\_states)

Description: A map of objects describing the Terraform remote states to include in the outputs of this module. The S3 storage and IAM policies for these remote states will be created by this module, unless the `create` attribute is set to `false.

The objects in this map support the following attributes:

- **bucket** (string, default: generated randomly): Name of the S3 bucket that will store Terraform states.
- **create** (bool, default: `true`): Whether to create the S3 bucket and DynamoDB table, or not.
- **create_access_policies** (bool, default: `true`): Whether to create IAM read-only and read-write access policies.
- **dynamodb_table** (string, default: bucket name): Name of the DynamoDB table that will be used for locking Terraform states.
- **force_destroy** (bool, default: `false`): Value of the `force\_destroy` attribute for the created S3 bucket. You should set this to `true` and apply the configuration before removing any element from the map in order to destroy the S3 bucket. Alternatively, you can empty the corresponding S3 bucket manually, before removing an element from the map.
- **policy_name_prefix** (string, default: based on map key): A common prefix to prepend to each managed IAM policy name. Defaults to a CamelCase mutation of the map key.
- **policy_name_suffix** (string, default: `""`): A common suffix to append to each managed IAM policy name.
`

Type: `any`

### <a name="input_tier"></a> [tier](#input\_tier)

Description: The value of the `Tier` tag for all resources created by this module.

Type: `string`

## Outputs

The following outputs are exported:

### <a name="output_access_policy_arns"></a> [access\_policy\_arns](#output\_access\_policy\_arns)

Description: A mapping between the keys used in the `terraform_remote_states` input variable and objects describing the corresponding managed IAM policies.

### <a name="output_terraform_remote_states"></a> [terraform\_remote\_states](#output\_terraform\_remote\_states)

Description: A mapping between the keys used in the `terraform_remote_states` input variable and objects describing the corresponding Terraform remote state backend.
<!-- END_TF_DOCS -->
