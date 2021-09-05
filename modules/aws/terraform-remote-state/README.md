# terraform-remote-state

This module can be used to create the necessary resources to store
[Terraform state in an S3 bucket](https://www.terraform.io/docs/language/settings/backends/s3.html),
and to control locking of the state via a DynamoDB table. It can also create two
IAM policies which provide either read-only, or read-write access to these
resources.

The `backend` and `config` outputs of this module can be used to generate a
Terraform S3 backend configuration.

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 3.53.0 |
| random | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.53.0 |
| random | >= 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| access_policies | ./modules/access-policies |  |
| backend_storage | ./modules/backend-storage |  |

## Resources

| Name |
|------|
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |
| [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket | The name of the S3 bucket that stores the Terraform state. If unset or empty, a random name will be generated automatically. | `string` | `""` | no |
| create | Whether to actually manage the S3 bucket and DynamoDB table, or to only generate a backend configuration object based on the input variables. | `bool` | `true` | no |
| create\_access\_policies | Whether to create customer managed IAM policies that govern access to the S3 bucket and DynamoDB table. | `bool` | `true` | no |
| dynamodb\_table | The name of the DynamoDB table that will be used to lock objects in the S3 bucket. Defaults to the name of the bucket. | `string` | `""` | no |
| encrypt | Whether to enable server-side encryption on the S3 bucket (or to assume that it is enabled when `create` is `false`). | `bool` | `true` | no |
| force\_destroy | A boolean that indicates all objects (including any locked objects) should be deleted from the bucket before destroying the bucket, so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |
| policy\_name\_prefix | A prefix to prepend to the names of all managed IAM policies. | `string` | `""` | no |
| policy\_name\_suffix | A suffix to append to the names of all managed IAM policies. | `string` | `""` | no |
| policy\_path | The IAM path under which to create the IAM policies. | `string` | `"/"` | no |
| read\_only\_policy\_name | The middle part of the name of the IAM policy which grants read-only access to the S3 bucket. | `string` | `"TerraformStateReadOnlyAccess"` | no |
| read\_write\_policy\_name | The middle part of the name of the IAM policy which grants read-write access to the S3 bucket, and DynamoDB table. | `string` | `"TerraformStateReadWriteAccess"` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_policy\_arns | A mapping between the names of all IAM policies managed by this module and their corresponding ARNs. |
| backend | The name of the [Terraform remote state backend](https://www.terraform.io/docs/language/settings/backends/index.html) that this module created the required resources for. This will always be the value `"s3"`. |
| config | An object describing the [S3 backend](https://www.terraform.io/docs/language/settings/backends/s3.html) configuration. |
| read\_only\_access\_policy\_name | The name of the managed IAM policy which grants read-only access to the S3 bucket. If the `create_access_policies` variable is `false`, then this value will be an empty string. |
| read\_write\_access\_policy\_name | The name of the managed IAM policy which grants read-write access to the S3 bucket and DynamoDB table. If the `create_access_policies` variable is `false`, then this value will be an empty string. |

<!--- END_TF_DOCS --->
