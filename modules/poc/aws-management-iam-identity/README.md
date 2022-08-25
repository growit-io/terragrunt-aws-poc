# aws-management-iam-identity

This Terraform module creates IAM users, manages their group memberships, and
optionally creates a managed access key (normally only for non-human service
accounts.)

The `aws` provider will be configured to use the current AWS credentials which
are expected to provide administrative access to the organization management
account.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| aws | ~> 3.53.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.53.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_iam_access_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) |
| [aws_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) |
| [aws_iam_user_group_membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| git\_repository | The value of the `GitRepository` tag for all resources created by this module. | `string` | n/a | yes |
| groups | A set of names of IAM groups that are assumed to exist in the AWS Organizations management account. | `set(string)` | n/a | yes |
| layer | The value of the `Layer` tag for all resources created by this module. | `string` | n/a | yes |
| organization | The value of the `Organization` tag for all resources created by this module. | `string` | n/a | yes |
| region | The region to configure for the default `aws` provider in this module. | `string` | n/a | yes |
| stack | The value of the `Stack` tag for all resources created by this module. | `string` | n/a | yes |
| stage | The value of the `Stage` tag for all resources created by this module. | `string` | n/a | yes |
| tier | The value of the `Tier` tag for all resources created by this module. | `string` | n/a | yes |
| users | A map of objects describing the IAM users to create in the AWS Organizations management account.<br><br>The map keys are the names of the IAM users to create and the values support the following attributes:<br><br>- **access\_key** (`bool`, default: `false`): Whether to create an access key for the user.<br>- **groups** (`set(string)`, default: `[]`): The names of IAM groups which the user should be a member of. Each name must correspond to a map key in the `groups` variable.<br>- **path** (`string`, default: `"/"`): The IAM path under which to create the user.<br>- **pgp\_key** (`string`, default: `null`): A base64-encoded PGP public key to encrypt the secret access key with. If a PGP key is specified, then the resulting access key will not be directly usable by other Terraform root modules and the secret key will be returned in the `encrypted_access_keys` output, instead of in the `plaintext_access_keys` output. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_keys | A mapping between IAM user name and access key ID for each user that has an access key managed by this module. |
| encrypted\_access\_keys | A mapping between IAM user name and access key, where the secret access key is a base64-encoded value encrypted with the PGP key given in the `pgp_key` attribute in the `users` input variable.<br><br>These access keys can not be used directly by other Terraform root modules without decrypting them first. |
| plaintext\_access\_keys | A mapping between IAM user name and access key, where the secret access key is stored unencrypted in the Terraform state.<br><br>These access keys are directly suitable for consumption by other Terraform root modules, but will be stored in plain text in the Terraform state, which means the current Terraform state must be treated as sensitive as well and be readable only by authorized users. |
| users | The set of names of all IAM users managed by this module. |

<!-- END_TF_DOCS -->
