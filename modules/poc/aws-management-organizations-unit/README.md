# aws-management-organizations-unit

This Terraform module creates an
[AWS Organizations](https://aws.amazon.com/organizations/)
organizational unit (OU), and optionally creates and attaches policies to the
OU.

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
| [aws_organizations_organizational_unit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) |
| [aws_organizations_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) |
| [aws_organizations_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| git\_repository | The value of the `GitRepository` tag for all resources created by this module. | `string` | n/a | yes |
| layer | The value of the `Layer` tag for all resources created by this module. | `string` | n/a | yes |
| name | The name of the organizational unit to create. If empty, the name will be automatically generated based on the value of the `organization_unit` variable. | `string` | `""` | no |
| organization | The value of the `Organization` tag for all resources created by this module. | `string` | n/a | yes |
| organization\_policies | A map of objects describing organization policies to create and attach to the organizational unit.<br><br>The map keys should be usable as Terraform resource names and the objects must have the following attributes:<br><br>- **type** (string): The type of policy to create. For example, `SERVICE_CONTROL_POLICY`.<br>- **description** (string): A description of the policy.<br>- **content** (string): The policy document itself as an object suitable for [`jsonencode`](https://www.terraform.io/docs/language/functions/jsonencode.html). | <pre>map(object({<br>    type        = string<br>    description = string<br>    content     = any<br>  }))</pre> | `{}` | no |
| organizational\_unit | Used to construct the name of the organizational unit if the `name` variable is not given explicitly. This value should normally be provided automatically via the parent terragrunt.hcl file in this repository. | `string` | n/a | yes |
| parent | An object describing the parent of the organizational unit to create. This should be the outputs of either this module, or the [aws-management-organizations-root](../aws-management-organizations-root) module. | <pre>object({<br>    management_account_id    = string<br>    management_account_email = string<br><br>    organizational_unit = object({<br>      id = string<br>    })<br>  })</pre> | n/a | yes |
| region | The region to configure for the default `aws` provider in this module. | `string` | n/a | yes |
| stack | The value of the `Stack` tag for all resources created by this module. | `string` | n/a | yes |
| stage | The value of the `Stage` tag for all resources created by this module. | `string` | n/a | yes |
| tier | The value of the `Tier` tag for all resources created by this module. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| management\_account\_email | The email address of the organization's management account root user. |
| management\_account\_id | The AWS account ID of the organization's management account. |
| organizational\_unit | An object describing the organizational unit created by this module. |

<!--- END_TF_DOCS --->
