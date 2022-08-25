# Amazon Web Services Platform

This directory contains Terragrunt configurations for [Amazon Web Services][aws].
Each subdirectory represents a distinct [AWS Organizations][organizations]
organization with its own management account.

[aws]: https://aws.amazon.com/
[organizations]: https://aws.amazon.com/organizations/

[//]: # (TODO: link to examples)
<!--
To create a new organization configuration subdirectory, take a look a the
available [examples][examples].

[examples]: ../examples/aws/README.md
-->

## Terragrunt configuration conventions

The [`terragrunt.yml`](terragrunt.yml) file in this directory modifies the
conventions for all Terragrunt configurations below this hierarchy level.

### Terraform root module inputs

The following additional inputs are provided to all Terraform root modules via
`TF_VAR_` environment variables:

- **organization** (`string`): The name of the subdirectory which defines the
  respective organization configuration.
