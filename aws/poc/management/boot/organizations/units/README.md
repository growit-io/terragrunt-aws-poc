# Units Stack

This directory contains Terragrunt configurations for root-level organizational
units, and their attached policies. Each subdirectory represents a distinct
organizational unit.

## Terragrunt configuration conventions

The [`terragrunt.yml`](terragrunt.yml) file in this directory modifies the
conventions for all Terragrunt configurations below this hierarchy level.

### Terraform root module source

All configurations below this directory level will use the
[aws-management-organizations-unit](../../../../../../modules/poc/aws-management-organizations-unit)
root module.

### Terraform root module inputs

The following additional inputs are provided to all Terraform root modules via
`TF_VAR_` environment variables:

- **organizational_unit** (`string`): The name of the subdirectory which defines
  the respective organizational unit configuration.
