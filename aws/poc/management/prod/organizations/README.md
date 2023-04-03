# Organizations Layer

This directory contains Terragrunt configurations for
[AWS Organizations](https://aws.amazon.com/organizations/) resources that will
be used in the production stages of higher tiers. Each subdirectory represents a
distinct "stack" in the configuration of this layer.

## Terragrunt configuration conventions

The [`terragrunt.yml`](terragrunt.yml) file in this directory modifies the
conventions for all Terragrunt configurations below this hierarchy level.

### Terraform root module inputs

The following additional inputs are provided to all Terraform root modules via
`TF_VAR_` environment variables:

- **stack** (`string`): The name of the subdirectory which defines the
  respective configuration stack.
