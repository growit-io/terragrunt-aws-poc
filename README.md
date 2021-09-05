<img src="icon.png" align="right" width="25%" />

# Terragrunt Template
[![Upstream](https://github.com/growit-io/terragrunt/actions/workflows/upstream.yml/badge.svg)](https://github.com/growit-io/terragrunt/actions/workflows/upstream.yml)
[![Release](https://github.com/growit-io/terragrunt/actions/workflows/release.yml/badge.svg)](https://github.com/growit-io/terragrunt/actions/workflows/release.yml)
[![Downstream](https://github.com/growit-io/terragrunt/actions/workflows/downstream.yml/badge.svg)](https://github.com/growit-io/terragrunt/actions/workflows/downstream.yml)

This is a template for [Terragrunt](https://terragrunt.gruntwork.io/)
configuration repositories with a single parent `terragrunt.hcl` file that
supports simple configurations as well as complex, highly interdependent and
deeply nested scenarios.

This repository was generated from an
[abstract template](https://github.com/growit-io/template) and is
[automatically kept synchronized](.github/workflows) with new releases of the
template.

## Features

- [Hierarchically defined configurations](docs/terragrunt/README.md) via
  `terragrunt.yml` files to overcome the
  [single-include limitation](https://terragrunt.gruntwork.io/docs/rfc/imports/)
  and keep Terragrunt configurations as "DRY" as possible.
- [TFLint configuration](.tflint.hcl) to ensure that all Terraform modules in
  this repository meet basic quality standards.
- [commitlint configuration](.commitlint.config.js) to ensure that all commits
  follow the [Conventional Commits](https://www.conventionalcommits.org/)
  specification, so that semantically versioned releases can be created
  automatically.
- [GitHub workflows](.github/workflows) to validate pull requests, deploy
  configuration changes, create releases, and to automate miscellaneous
  maintenance chores.

## Usage

### Prerequisites for development

- [`tfenv`](https://github.com/tfutils/tfenv) and a
  [compatible version](.terraform-version) of Terraform installed
  via `tfenv install`
- [`tgenv`](https://github.com/cunymatthieu/tgenv) and a
  [compatible version](.terragrunt-version) of Terragrunt installed
  via `tgenv install`
- [GNU Make](https://www.gnu.org/software/make/) (already
  comes preinstalled on macOS), or a compatible implementation

### Typical development workflow

1. Clone the configuration repository on your local machine.
2. Change the configuration and verify your changes using `make plan`, or apply
   them directly using `make apply`.

   You can optionally pass a `paths=<patterns>` argument to the `make` command
   in order to run Terragrunt in a subset of directories. See the
   [`Makefile`](Makefile) for details on how the `paths` variable is handled.

   The default value of the `paths` variable will target all configurations.
3. Commit and push your changes to a branch and open a pull request. Make sure
   to read the [contributing guide](CONTRIBUTING.md), so that the pull request
   will be ready to be merged after review.
4. Wait for all status checks to complete, review execution plans and merge
   the pull request to apply any pending changes to non-production resources.
5. If you made any changes to production configurations, wait for the release
   pull request to be created and review its Terraform execution plan.
6. Merge the release pull request to apply any pending changes to production
   resources.

## Terragrunt configuration conventions

These are the top-level conventions which apply to all Terragrunt configurations
in this repository. Most subdirectories in the configuration directory hierarchy
will augment these conventions in some way via `terragrunt.yml` files. For more
details on this approach, and the recognized attributes in `terragrunt.yml`
files, see the [documentation](docs/terragrunt/README.md).

### Single parent `terragrunt.hcl` file

This repository provides a single parent [`terragrunt.hcl`](terragrunt.hcl) file
which is included by all child `terragrunt.hcl` files via an
[`include`](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#include)
block such as the following:

```hcl
include {
  path = find_in_parent_folders()
}
```

The parent `terragrunt.hcl`
is flexible enough to provide
[`terraform`](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#terraform)
and
[`remote_state`](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#remote_state)
blocks, as well as an
[`inputs`](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#inputs)
attribute which will normally be directly suitable for any
child `terragrunt.hcl` file in this repository. The only additional statements
in a child `terragrunt.hcl` file should be
[`dependency`](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#dependency)
blocks and configuration-specific inputs.

The following automatically generated graph shows the dependencies among all
Terragrunt configurations which include the parent `terragrunt.hcl` file:

![Dependency graph](graph.svg)

### Terraform root module source

The top-level [`terragrunt.yml`](terragrunt.yml) file specifies that all
Terraform root modules should be located under the [`modules`](modules)
directory in this repository. The root module naming convention is further
refined by additional `terragrunt.yml` files in the configuration directory
hierarchy.

### Terraform root module inputs

The following inputs are provided to every Terraform root module via `TF_VAR_`
environment variables:

- **git_branch** (`string`): The name of the currently checked out Git branch.
- **git_commit** (`string`): The SHA-1 hash of the latest commit on the
  currently checked out Git branch.
- **git_repository** (`string`): The URL of the `origin` remote in the Git
  repository configuration.
- **platform** (`string`): The name of the first subdirectory which leads to the
  child `terragrunt.hcl` file.
- **root_dir** (`string`): The absolute path of the directory which contains
  the parent `terragrunt.hcl` file.
- **terraform_remote_state_backend** (`string`): The name of the Terraform
  remote state for the current Terragrunt configuration.
- **terraform_remote_state_config** (`object(any)`): The configuration of the
  Terraform remote state backend for the current Terragrunt configuration.

## Documentation

The [`docs`](docs) directory contains the reference documentation for this
Terragrunt configuration repository.

## Changelog

All notable changes to this project will be documented in the
[`CHANGELOG.md`](CHANGELOG.md) file.

## Contributing

See the file [`CONTRIBUTING.md`](CONTRIBUTING.md) for contribution guidelines.

## License

[MIT License](LICENSE)
