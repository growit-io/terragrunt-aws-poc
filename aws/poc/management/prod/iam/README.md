# IAM Layer

This directory contains Terragrunt configurations for
[AWS IAM](https://aws.amazon.com/iam/) resources in the management account.
Each subdirectory represents a distinct "stack" in the configuration of this
layer.

## Terragrunt configuration conventions

The [`terragrunt.yml`](terragrunt.yml) file in this directory modifies the
conventions for all Terragrunt configurations below this hierarchy level.

### Terraform root module source

This directory extends the Terraform module source convention. The source of all
Terraform root modules used in configurations below this directory must include
the `${stack}` suffix.

### Terraform root module inputs

The following additional inputs are provided to all Terraform root modules via
`TF_VAR_` environment variables:

- **stack** (`string`): The name of the subdirectory which defines the
  respective configuration stack.
