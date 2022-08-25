# aws-management-organizations-root

This Terraform module creates the
[AWS Organizations](https://aws.amazon.com/organizations/)
organization itself, and optionally creates and attaches policies to the
organization.

The `aws` provider is will use the currently configured AWS credentials, which
are expected to provide administrative access to the organization management
account.

<!-- BEGIN_TF_DOCS -->
## Resources

The following resources are used by this module:

- [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) (resource)
- [aws_organizations_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) (resource)
- [aws_organizations_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) (resource)

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

### <a name="input_aws_service_access_principals"></a> [aws\_service\_access\_principals](#input\_aws\_service\_access\_principals)

Description: List of AWS service principal names for which you want to enable integration  
with your organization. This is typically in the form of a URL, such as  
service-abbreviation.amazonaws.com. Organization must have feature\_set set  
to ALL. For additional information, see the AWS Organizations User Guide.

Type: `set(string)`

Default: `[]`

### <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types)

Description: List of Organizations policy types to enable in the Organization Root.  
Organization must have feature\_set set to ALL. For additional information  
about valid policy types (e.g. AISERVICES\_OPT\_OUT\_POLICY, BACKUP\_POLICY,  
SERVICE\_CONTROL\_POLICY, and TAG\_POLICY), see the AWS Organizations API  
Reference.

Type: `set(string)`

Default: `[]`

### <a name="input_feature_set"></a> [feature\_set](#input\_feature\_set)

Description: Specify "ALL" (default) or "CONSOLIDATED\_BILLING".

Type: `string`

Default: `"ALL"`

### <a name="input_organization_policies"></a> [organization\_policies](#input\_organization\_policies)

Description: A map of objects describing organization policies to create and attach to the organization at the root level.

The map keys should be usable as Terraform resource names and the objects must have the following attributes:

- **type** (string): The type of policy to create. For example, `SERVICE_CONTROL_POLICY`.
- **description** (string): A description of the policy.
- **content** (string): The policy document itself as an object suitable for the [jsonencode](https://www.terraform.io/docs/language/functions/jsonencode.html) function.

Type:

```hcl
map(object({
    type        = string
    description = string
    content     = any
  }))
```

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_management_account_email"></a> [management\_account\_email](#output\_management\_account\_email)

Description: The email address of the organization's management account root user.

### <a name="output_management_account_id"></a> [management\_account\_id](#output\_management\_account\_id)

Description: The AWS account ID of the organization's management account.

### <a name="output_organizational_unit"></a> [organizational\_unit](#output\_organizational\_unit)

Description: An object describing the root organizational unit of the organization.
<!-- END_TF_DOCS -->
