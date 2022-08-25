# aws-management-iam-access

This Terraform module creates IAM groups and IAM policies that may be attached
to these groups to control access to organization member accounts and resources
in the management account itself.

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

| Name | Version |
|------|---------|
| aws | ~> 3.53.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_iam_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) |
| [aws_iam_group_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| git\_repository | The value of the `GitRepository` tag for all resources created by this module. | `string` | n/a | yes |
| groups | A map of objects describing the IAM groups to create in the AWS Organization management account.<br><br>The map keys are the names of the IAM groups and the map values require the following attributes:<br><br>- **path** (`string`, default: `"/"`): IAM path under which to create the group.<br>- **policies** (`set(string)`): The names or ARNs of IAM policies to attach to the group. When IAM policy names are given instead of ARNs, the names must correspond to a map key in either the `policies`, or the `policy_arns` input variable. | `any` | `{}` | no |
| layer | The value of the `Layer` tag for all resources created by this module. | `string` | n/a | yes |
| organization | The value of the `Organization` tag for all resources created by this module. | `string` | n/a | yes |
| policies | A map of objects describing managed IAM policies to create in the AWS Organizations management account. The names of these managed IAM policies are automatically available for reference in the `groups` input variable.<br><br>The map keys correspond to the IAM policy names and the map values support the following attributes:<br><br>- **description** (`string`): Description of the IAM policy.<br>- **path** (`string`, default: `"/"`): IAM path under which to create the policy.<br>- **policy** (`string`): IAM policy document object suitable for [`jsonencode`](https://www.terraform.io/docs/language/functions/jsonencode.html). | `any` | `{}` | no |
| policy\_arns | A map of IAM policy names and corresponding ARNs that will be available for referencing in the `groups` variable. | `map(string)` | `{}` | no |
| region | The region to configure for the default `aws` provider in this module. | `string` | n/a | yes |
| stack | The value of the `Stack` tag for all resources created by this module. | `string` | n/a | yes |
| stage | The value of the `Stage` tag for all resources created by this module. | `string` | n/a | yes |
| tier | The value of the `Tier` tag for all resources created by this module. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| groups | The names of IAM groups managed by this module. |

<!--- END_TF_DOCS --->
