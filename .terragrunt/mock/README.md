# mock

This Terragrunt configuration has no inputs, no outputs, and it doesn't manage
any resources. The only reason it exists is that Terragrunt does not support
optional dependencies. The [parent `terragrunt.hcl`](../../terragrunt.hcl) file
in this repository will conditionally point to this module when a dependency is
not required by the current child `terragrunt.hcl` file.

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.11 |

## Providers

No provider.

## Modules

No Modules.

## Resources

No resources.

## Inputs

No input.

## Outputs

No output.

<!--- END_TF_DOCS --->
