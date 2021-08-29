# Terragrunt Configurations for Amazon Web Services
[![Upstream](https://github.com/growit-io/terragrunt-aws-poc/actions/workflows/upstream.yml/badge.svg)](https://github.com/growit-io/terragrunt-aws-poc/actions/workflows/upstream.yml)
[![Release](https://github.com/growit-io/terragrunt-aws-poc/actions/workflows/release.yml/badge.svg)](https://github.com/growit-io/terragrunt-aws-poc/actions/workflows/release.yml)

This is a proof-of-concept Terragrunt configuration repository for Amazon Web
Services based on the
[terragrunt-aws](https://github.com/growit-io/terragrunt-aws) template.

This repository includes a single [parent `terragrunt.hcl`](terragrunt.hcl) that
is included by all child `terragrunt.hcl` files. The parent `terragrunt.hcl`
file provides `terragrunt` and `remote_state` blocks, as well as an `inputs`
attribute whose value will be the result of merging the `inputs` attributes of
all `terragrunt.yml` files in the directory hierarchy.

For more details on this approach, and the definition of supported attributes
in `terragrunt.yml` files, see the [documentation](docs/terragrunt/README.md).

## Features

### GitHub workflows

- [**Integration**](.github/workflows/integration.yml): Validates all commit
  messages using `commitlint` and creates Terraform execution plans for all
  non-production configurations.
- [**Release**](.github/workflows/release.yml): Maintains a changelog, release
  tags, and releases on GitHub and applies changes in either non-production, or
  production configurations, depending on whether a release was created.
- [**Upstream**](.github/workflows/upstream.yml): Keeps this repository
  synchronized with the template that it was created from.

## Usage

1. Change the configuration and verify your changes using `make plan`. You can
   optionally pass a `paths=<pattern>` variable to the `make` command in order
   to run Terragrunt in a specific subset of directories. See the
   [`Makefile`](Makefile) for details on how the `paths` variable is handled.
2. Commit and push your changes to a branch and open a pull request.
3. Wait for the status checks to complete, review execution plans and merge
   the pull request to apply any changes made to non-development configurations.
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

All relevant changes to this project are documented in the file
[CHANGELOG.md](CHANGELOG.md).

## Contributing

See the file [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## License

[MIT License](LICENSE)
