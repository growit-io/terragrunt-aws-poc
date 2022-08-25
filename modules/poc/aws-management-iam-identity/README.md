# aws-management-iam-identity

This Terraform module creates IAM users, manages their group memberships, and
optionally creates a managed access key (normally only for non-human service
accounts.)

The `aws` provider will be configured to use the current AWS credentials which
are expected to provide administrative access to the organization management
account.

<!-- BEGIN_TF_DOCS -->
## Resources

The following resources are used by this module:

- [aws_iam_access_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) (resource)
- [aws_iam_user.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) (resource)
- [aws_iam_user_group_membership.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_git_repository"></a> [git\_repository](#input\_git\_repository)

Description: The value of the `GitRepository` tag for all resources created by this module.

Type: `string`

### <a name="input_groups"></a> [groups](#input\_groups)

Description: A set of names of IAM groups that are assumed to exist in the AWS Organizations management account.

Type: `set(string)`

### <a name="input_layer"></a> [layer](#input\_layer)

Description: The value of the `Layer` tag for all resources created by this module.

Type: `string`

### <a name="input_organization"></a> [organization](#input\_organization)

Description: The value of the `Organization` tag for all resources created by this module.

Type: `string`

### <a name="input_region"></a> [region](#input\_region)

Description: The region to configure for the default `aws` provider in this module.

Type: `string`

### <a name="input_stack"></a> [stack](#input\_stack)

Description: The value of the `Stack` tag for all resources created by this module.

Type: `string`

### <a name="input_stage"></a> [stage](#input\_stage)

Description: The value of the `Stage` tag for all resources created by this module.

Type: `string`

### <a name="input_tier"></a> [tier](#input\_tier)

Description: The value of the `Tier` tag for all resources created by this module.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_users"></a> [users](#input\_users)

Description: A map of objects describing the IAM users to create in the AWS Organizations management account.

The map keys are the names of the IAM users to create and the values support the following attributes:

- **access\_key** (`bool`, default: `false`): Whether to create an access key for the user.
- **groups** (`set(string)`, default: `[]`): The names of IAM groups which the user should be a member of. Each name must correspond to a map key in the `groups` variable.
- **path** (`string`, default: `"/"`): The IAM path under which to create the user.
- **pgp\_key** (`string`, default: `null`): A base64-encoded PGP public key to encrypt the secret access key with. If a PGP key is specified, then the resulting access key will not be directly usable by other Terraform root modules and the secret key will be returned in the `encrypted_access_keys` output, instead of in the `plaintext_access_keys` output.

Type: `any`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_access_keys"></a> [access\_keys](#output\_access\_keys)

Description: A mapping between IAM user name and access key ID for each user that has an access key managed by this module.

### <a name="output_encrypted_access_keys"></a> [encrypted\_access\_keys](#output\_encrypted\_access\_keys)

Description: A mapping between IAM user name and access key, where the secret access key is a base64-encoded value encrypted with the PGP key given in the `pgp_key` attribute in the `users` input variable.

These access keys can not be used directly by other Terraform root modules without decrypting them first.

### <a name="output_plaintext_access_keys"></a> [plaintext\_access\_keys](#output\_plaintext\_access\_keys)

Description: A mapping between IAM user name and access key, where the secret access key is stored unencrypted in the Terraform state.

These access keys are directly suitable for consumption by other Terraform root modules, but will be stored in plain text in the Terraform state, which means the current Terraform state must be treated as sensitive as well and be readable only by authorized users.

### <a name="output_users"></a> [users](#output\_users)

Description: The set of names of all IAM users managed by this module.
<!-- END_TF_DOCS -->
