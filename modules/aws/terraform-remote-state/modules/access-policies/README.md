# access-policies

This Terraform module creates two IAM policies granting either read-only, or
read-write access to a given set of
[Terraform S3 backend](https://www.terraform.io/docs/language/settings/backends/s3.html)
resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| aws | >= 3.53.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.53.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket | The name of an S3 bucket used as Terraform state storage. | `string` | n/a | yes |
| dynamodb\_table | The name of a DynamoDB table used for locking objects in the S3 bucket. | `string` | n/a | yes |
| name\_prefix | A prefix to prepend to the names of all managed IAM policies. | `string` | n/a | yes |
| name\_suffix | A suffix to append to the names of all managed IAM policies. | `string` | n/a | yes |
| path | The IAM path under which to create the IAM policies. | `string` | n/a | yes |
| read\_only\_name | The middle part of the name of the IAM policy which grants read-only access to the S3 bucket. | `string` | n/a | yes |
| read\_write\_name | The middle part of the name of the IAM policy which grants read-write access to the S3 bucket, and DynamoDB table. | `string` | n/a | yes |
| region | The region in which the S3 bucket was created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_arns | A mapping between the names of managed IAM policies and their ARNs. |
| read\_only\_policy\_name | The name of the managed IAM policy which grants read-only access to the S3 bucket. |
| read\_write\_policy\_name | The name of the managed IAM policy which grants read-write access to the S3 bucket and DynamoDB table. |

<!-- END_TF_DOCS -->
