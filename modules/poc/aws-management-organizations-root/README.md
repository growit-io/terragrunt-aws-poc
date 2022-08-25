# aws-management-organizations-root

This Terraform module creates the
[AWS Organizations](https://aws.amazon.com/organizations/)
organization itself, and optionally creates and attaches policies to the
organization.

The `aws` provider is will use the currently configured AWS credentials, which
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
| [aws_organizations_organization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) |
| [aws_organizations_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) |
| [aws_organizations_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_service\_access\_principals | List of AWS service principal names for which you want to enable integration<br>with your organization. This is typically in the form of a URL, such as<br>service-abbreviation.amazonaws.com. Organization must have feature\_set set<br>to ALL. For additional information, see the AWS Organizations User Guide. | `set(string)` | `[]` | no |
| enabled\_policy\_types | List of Organizations policy types to enable in the Organization Root.<br>Organization must have feature\_set set to ALL. For additional information<br>about valid policy types (e.g. AISERVICES\_OPT\_OUT\_POLICY, BACKUP\_POLICY,<br>SERVICE\_CONTROL\_POLICY, and TAG\_POLICY), see the AWS Organizations API<br>Reference. | `set(string)` | `[]` | no |
| feature\_set | Specify "ALL" (default) or "CONSOLIDATED\_BILLING". | `string` | `"ALL"` | no |
| git\_repository | The value of the `GitRepository` tag for all resources created by this module. | `string` | n/a | yes |
| layer | The value of the `Layer` tag for all resources created by this module. | `string` | n/a | yes |
| organization | The value of the `Organization` tag for all resources created by this module. | `string` | n/a | yes |
| organization\_policies | A map of objects describing organization policies to create and attach to the organization at the root level.<br><br>The map keys should be usable as Terraform resource names and the objects must have the following attributes:<br><br>- **type** (string): The type of policy to create. For example, `SERVICE_CONTROL_POLICY`.<br>- **description** (string): A description of the policy.<br>- **content** (string): The policy document itself as an object suitable for the [jsonencode](https://www.terraform.io/docs/language/functions/jsonencode.html) function. | <pre>map(object({<br>    type        = string<br>    description = string<br>    content     = any<br>  }))</pre> | `{}` | no |
| region | The region to configure for the default `aws` provider in this module. | `string` | n/a | yes |
| stack | The value of the `Stack` tag for all resources created by this module. | `string` | n/a | yes |
| stage | The value of the `Stage` tag for all resources created by this module. | `string` | n/a | yes |
| tier | The value of the `Tier` tag for all resources created by this module. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| management\_account\_email | The email address of the organization's management account root user. |
| management\_account\_id | The AWS account ID of the organization's management account. |
| organizational\_unit | An object describing the root organizational unit of the organization. |

<!-- END_TF_DOCS -->
