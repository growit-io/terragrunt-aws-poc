# Proof-of-Concept Organization

This directory contains Terragrunt configurations for a hypothetical
[AWS Organizations](https://aws.amazon.com/organizations/)
organization named "poc." Each subdirectory represents a distinct "tier" of the
configuration.

## Terragrunt configuration conventions

The [`terragrunt.yml`](terragrunt.yml) file in this directory modifies the
conventions for all Terragrunt configurations below this hierarchy level.

### Terraform root module source

This directory extends the top-level root module source convention by specifying
that all Terraform root modules should reside in the `${organization}` directory,
and that module names should start with the prefix `${platform}-${tier}-`.

### Terraform root module inputs

The following additional inputs are provided to all Terraform root modules via
`TF_VAR_` environment variables:

- **default_region** (`string`): The default AWS region in which to operate
  when no other region is explicitly passed to the root module.
- **tier** (`string`): The name of the subdirectory which defines the respective
  configuration tier.
