# Makefile Fragments

This directory contains [GNU Make][gnu-make] fragments to be included by all
`Makefile` files in this repository in order to avoid duplication of common
logic and to keep the development and testing workflows consistent in every
directory.

[gnu-make]: https://www.gnu.org/software/make/

## Table of contents

- [Why Make?](#why-make)
- [Compatibility](#compatibility)
- [Dependencies](#dependencies)
  - [Installation on macOS](#installation-on-macos)
- [Documentation](#documentation)

## Why Make?

Using Make provides a lot of benefits over a loose collection of shell scripts,
such as recursive invocation, dependency-based ordering of steps, variable
override handling via arguments or environment variables, and more. Make is also
proven to work at scale in large software projects, for example the
[FreeBSD Ports][freebsd-ports] collection.

Basing the development and testing workflows for Terraform on Make also has the
benefit of making it easy to execute the same workflows in local development and
automated CI/CD environments.

There are many tools similar to Make and none of them are "perfect" for all
scenarios. However, Make is often bundled in operating system distributions or
basic software development add-on packages and uses a simple declarative syntax
which doesn't require knowing a particular programming language very well.

[freebsd-ports]: https://github.com/freebsd/freebsd-ports

## Compatibility

The fragments in this directory use GNU Make extensions. Other implementations
of the `make` command, for example BSD Make or POSIX-compatible implementations
are not supported. The minimum required version is GNU Make 3.81, since it added
the `lastword` builtin function.

## Dependencies

The following software dependencies must be satisfied to support the workflows
defined in these Makefile fragments:

- [Git][git]
- [GNU Make][gnu-make] (>= 3.81)
- [Terraform][terraform]
- [Terragrunt][terragrunt]
- [TFLint][tflint]
- [terraform-docs][terraform-docs]
- [Go][go]

[git]: https://git-scm.com/
[terraform]: https://github.com/hashicorp/terraform
[terragrunt]: https://github.com/gruntwork-io/terragrunt
[tflint]: https://github.com/terraform-linters/tflint
[terraform-docs]: https://github.com/terraform-docs/terraform-docs
[go]: https://golang.org/

### Installation on macOS

1. Install required and recommended system software via [Homebrew][homebrew],
   but don't install Terraform or Terragrunt, yet.
   ```bash
   brew install tfenv tgenv tflint terraform-docs go
   ```
2. Clone this repository and run the following commands in your local working
   copy to install the required versions of Terraform and Terragrunt specified
   in [.terraform-version](../.terraform-version)
   and [.terragrunt-version](../.terragrunt-version), respectively.
   ```bash
   tfenv install
   tgenv install
   ```
3. Check the documentation of the [config.mk](config.md) fragment for required
   configuration files and variables.

[Homebrew]: https://brew.sh/

## Documentation

The following table summarizes the most important Makefile fragments and links
to their documentation. The order in which they are presented here roughly
reflects how important it may be for a developer to be familiar with them in
order to work with this repository.

| Fragment | Summary |
| --- | --- |
| [config.mk](config.md) | Loads a user-defined Makefile fragment and ensures that common variables required by other fragments are defined |
| [subdir.mk](subdir.md) | Handles recursive processing of subdirectories, possibly limited to a subset of directories which contain changes in the working tree |
| [module.mk](module.md) | Provides common rules for all Terraform modules to ensure consistent formatting, documentation, and other best practices |
| [example.mk](example.md) | Ensures that a Terraform module example scenario can be applied without errors and automatically detects whether to invoke Terraform or Terragrunt |
| [test.mk](test.md) | Validates working examples with test suites implemented in Go |
| [terragrunt.mk](terragrunt.md) | Processes a single Terragrunt configuration directory |
| [terragrunt.run-all.mk](terragrunt.run-all.md) | Handles recursive processing of Terragrunt configuration directories |

## License

[MIT License](LICENSE)
