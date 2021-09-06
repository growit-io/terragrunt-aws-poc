# aws-management-organizations-account

This Terraform module creates an
[AWS Organizations](https://aws.amazon.com/organizations/)
member account, and optionally creates and attaches policies to the account.

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
| aws.member | ~> 3.53.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_organizations_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) |
| [aws_organizations_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) |
| [aws_organizations_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account | The name of the AWS Organizations member account to create. | `string` | n/a | yes |
| email | An explicit email address to use for the root user of the member account. If unset, this will be generated automatically based on the management account's root user email address, and the member account name. | `string` | `""` | no |
| email\_separator | The separator string to expect in the management account email address, and to use when constructing the email address of the member account's root user. | `string` | `"+"` | no |
| git\_repository | The value of the `GitRepository` tag for all resources created by this module. | `string` | n/a | yes |
| layer | The value of the `Layer` tag for all resources created by this module. | `string` | n/a | yes |
| organization | The value of the `Organization` tag for all resources created by this module. | `string` | n/a | yes |
| organization\_policies | A map of objects describing organization policies to create and attach to the organization member account.<br><br>The map keys should be usable as Terraform resource names and the objects must have the following attributes:<br><br>- **type** (string): The type of policy to create. For example, `SERVICE_CONTROL_POLICY`.<br>- **description** (string): A description of the policy.<br>- **content** (string): The policy document itself as an object suitable for the [jsonencode](https://www.terraform.io/docs/language/functions/jsonencode.html) function. | <pre>map(object({<br>    type        = string<br>    description = string<br>    content     = any<br>  }))</pre> | `{}` | no |
| parent | An object describing the parent of the AWS Organizations member account to create. This should be the outputs of either the [aws-management-organizations-unit](../aws-management-organizations-unit), or the [aws-management-organizations-root](../aws-management-organizations-root) module. | <pre>object({<br>    management_account_email = string<br><br>    organizational_unit = object({<br>      id = string<br>    })<br>  })</pre> | n/a | yes |
| region | The region to configure for the default `aws` provider in this module. | `string` | n/a | yes |
| roles | A map of objects describing IAM roles to create in the member account. The<br>exclusive trusted principal of each role will be the AWS Organizations<br>management account.<br><br>Map keys should be CamelCase role names. The suffix `Role` will be automatically appended to each name by this module.<br><br>Map values support the following attributes:<br><br>- **description** (`string`): A description of the role.<br>- **path** (`string`, default: `"/"`): The IAM path under which to create the role.<br>- **inline\_policies** (`set(object({name = string, policy=any}))`): A set of IAM policies to define as inline policies for the role. The `policy` attribute should be an IAM policy document object suitable for [`jsonencode`](https://www.terraform.io/docs/language/functions/jsonencode.html). | `map(any)` | `{}` | no |
| stack | The value of the `Stack` tag for all resources created by this module. | `string` | n/a | yes |
| stage | The value of the `Stage` tag for all resources created by this module. | `string` | n/a | yes |
| tier | The value of the `Tier` tag for all resources created by this module. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| email | The email address of the root user of the managed AWS Organizations member account. |
| id | The ID of the managed AWS Organizations member account. |
| name | The name of the managed AWS Organizations member account. |
| policy\_arns | A mapping between policy name and ARN for each IAM policy managed by this module. |
| role\_arns | A mapping between role name and ARN for each IAM role managed by this module. |

<!--- END_TF_DOCS --->
