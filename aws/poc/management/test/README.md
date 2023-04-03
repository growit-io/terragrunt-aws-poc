# Development Stage

This directory contains the configurations for all testing resources in the
management account. Each subdirectory represents a distinct configuration
"layer."

## Terragrunt configuration conventions

The [`terragrunt.yml`](terragrunt.yml) file in this directory modifies the
conventions for all Terragrunt configurations below this hierarchy level.

### Terraform remote state backend

All configurations below this directory will use the backend configuration
named `management_test` as defined by the
[../boot/terraform-state](../boot/terraform-state) configuration.

### Terraform root module source

This directory extends the Terraform module source convention. The source of all
Terraform root modules used in configurations below this directory must include
the `${layer}-` component.

### Terraform root module inputs

The following additional inputs are provided to all Terraform root modules via
`TF_VAR_` environment variables:

- **layer** (`string`): The name of the subdirectory which defines the
  respective configuration layer.
