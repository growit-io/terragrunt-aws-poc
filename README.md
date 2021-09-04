# Organization Configuration for Amazon Web Services
[![Release](https://github.com/growit-io/terragrunt-aws-poc/actions/workflows/release.yml/badge.svg)](https://github.com/growit-io/terragrunt-aws-poc/actions/workflows/release.yml)
[![Upstream](https://github.com/growit-io/terragrunt-aws-poc/actions/workflows/upstream.yml/badge.svg)](https://github.com/growit-io/terragrunt-aws-poc/actions/workflows/upstream.yml)

This is a proof-of-concept Terragrunt configuration repository for an entire
[AWS Organizations](https://aws.amazon.com/organizations/)
organization on Amazon Web Services.

This repository includes a single [parent `terragrunt.hcl`](terragrunt.hcl) that
is included by all child `terragrunt.hcl` files. The parent `terragrunt.hcl`
file provides
[`terraform`](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#terraform)
and
[`remote_state`](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#remote_state)
blocks, as well as an
[`inputs`](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#inputs)
attribute whose value will be the result of merging the `inputs` attributes of
all `terragrunt.yml` files in the directory hierarchy.

For more details on this approach, and the supported attributes in
`terragrunt.yml` files, see the
[feature documentation](docs/terragrunt/README.md).

This repository was originally generated from the
[terragrunt-aws](https://github.com/growit-io/terragrunt-aws) template, and is
[automatically kept synchronized](.github/workflows) with new releases of the
template.

## Features

- [Hierarchically defined Terragrunt configurations](docs/terragrunt/README.md)
  via `terragrunt.yml` files to overcome some limitations, and to extend
  Terragrunt's core functionality.
  - [Flexible directory layout for simple and complex use cases](docs/terragrunt/README.md#the-layer-attribute)
  - [Hierarchically defined Terraform root module inputs](docs/terragrunt/README.md#the-inputs-attribute)
  - [Conventions-based Terraform root module selection](docs/terragrunt/README.md#the-terraform-attribute)
  - [Terraform-managed state backend configurations](docs/terragrunt/README.md#the-remote_state-attribute)
- [Terragrunt configurations](aws/poc) that follow AWS recommendations for
  [organizing environments using multiple accounts](https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/organizing-your-aws-environment.html).
- [TFLint configuration](.tflint.hcl) to ensure that all Terraform modules are
  robust and well-documented.
- [commitlint configuration](commitlint.config.js) to ensure that all commits
  follow the [Conventional Commits](https://www.conventionalcommits.org/)
  specification, so that semantically versioned releases can be created
  automatically.
- [GitHub workflows](.github/workflows) to validate pull requests, to deploy
  Terragrunt configurations whenever changes are merged into the main branch,
  and to perform many other types of maintenance chores.

## Usage

1. Change the configuration and verify your changes using `make plan`. You can
   optionally pass a `paths=<pattern>` variable to the `make` command in order
   to run Terragrunt in a specific subset of directories. See the
   [`Makefile`](Makefile) for details on how the `paths` variable is handled.
2. Commit and push your changes to a branch and open a pull request.
3. Wait for the status checks to complete, review execution plans and merge
   the pull request to apply any changes made to non-production configurations.
4. If you made any changes to production configurations, wait for the release
   pull request to be created and review its Terraform execution plan.
5. Merge the release pull request to apply all changes made to production
   configurations.

## Directory index

- [aws](aws): Contains `terragrunt.yml` files and Terragrunt configurations
  (child `terragrunt.hcl` files) for Amazon Web Services.
- [examples](examples): Contains examples that you can learn from, or copy
  directly into the root of this repository to get started.
- [modules](modules): Should contain all Terraform root modules used by
  Terragrunt configurations in the `aws` directory, and required child modules.
- [docs](docs): Reference documentation for this Terragrunt configuration
  repository.

## Configuration structure

![Dependency graph](graph.svg)

## Changelog

All notable changes to this project will be documented in the
[CHANGELOG.md](CHANGELOG.md) file.

## Contributing

See the file [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## License

[MIT License](LICENSE)
