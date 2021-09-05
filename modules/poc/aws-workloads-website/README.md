# aws-workloads-website

This Terraform module creates a static example website hosted in an S3 bucket.

The `aws` provider will be configured to use the current AWS credentials to
assume the `WebsiteAdministrator` role in the specified target account.

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0.4 |
| aws | ~> 3.53.0 |

## Providers

No provider.

## Modules

| Name | Source | Version |
|------|--------|---------|
| this | ../../aws/s3-website-example |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account | An object describing the AWS account in which the S3 website should be deployed. This should normally be the outputs of the [aws-management-organizations-account](../aws-management-organizations-account/README.md) module.<br><br>    Specifically, this module expects an output named `role_arns.WebsiteAdministrator`, whose value will be passed to the `role_arn` attribute of the default `aws` provider.<br><br>    The `name` attribute of this object is used as the value of the `Acount` tag for all resources created by this module. | <pre>object({<br>    name = string<br>    role_arns = object({<br>      WebsiteAdministrator = string<br>    })<br>  })</pre> | n/a | yes |
| default\_region | The default region in which to deploy the website, if no value is provided for the `region` variable. This should normally be an organization-wide default value provided via the `TF_VAR_default_region` environment variable. | `string` | n/a | yes |
| git\_repository | The value of the `GitRepository` tag for all resources created by this module. | `string` | n/a | yes |
| layer | The value of the `Layer` tag for all resources created by this module. | `string` | n/a | yes |
| organization | The value of the `Organization` tag for all resources created by this module. | `string` | n/a | yes |
| region | The region in which to deploy the website. Defaults to the value of the `default_region` variable. | `string` | `""` | no |
| stage | The value of the `Stage` tag for all resources created by this module. | `string` | n/a | yes |
| tier | The value of the `Tier` tag for all resources created by this module. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| url | The HTTP URL of the S3 website. |

<!--- END_TF_DOCS --->