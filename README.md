# Terragrunt Template
[![Upstream](https://github.com/growit-io/terragrunt/actions/workflows/upstream.yml/badge.svg)](https://github.com/growit-io/terragrunt/actions/workflows/upstream.yml)
[![Release](https://github.com/growit-io/terragrunt/actions/workflows/release.yml/badge.svg)](https://github.com/growit-io/terragrunt/actions/workflows/release.yml)
[![Downstream](https://github.com/growit-io/terragrunt/actions/workflows/downstream.yml/badge.svg)](https://github.com/growit-io/terragrunt/actions/workflows/downstream.yml)

This is a template for Terragrunt configuration repositories on GitHub with
workflows to keep generated repositories synchronized with new releases of the
template.

This repository includes a single [parent `terragrunt.hcl`](terragrunt.hcl) that
should be included by all child `terragrunt.hcl` files. The parent
`terragrunt.hcl` file provides `terragrunt` and `remote_state` blocks, as well
as an `inputs` attribute whose value will be the result of merging the `inputs`
attributes of all `terragrunt.yml` files in the directory hierarchy.

For more details on this approach, and the definition of supported attributes
in `terragrunt.yml` files, see the [documentation](docs/terragrunt/README.md).

## Features

### GitHub workflows

- [**Integration**](.github/workflows/integration.yml): Validates all commit
  messages using `commitlint`.
- [**Release**](.github/workflows/release.yml): Maintains a changelog, release
  tags, and releases on GitHub.
- [**Downstream**](.github/workflows/downstream.yml): Notifies repositories
  created from this template of new releases.
- [**Upstream**](.github/workflows/upstream.yml): Keeps this repository
  synchronized with the template that it was created from.

### GitHub actions

- [**Remote Merge**](.github/actions/remote-merge): Merges the history of a
  branch or tag in another repository into this repository.

## Usage

1. Create a new repository on GitHub using this repository as a template.
2. Wait for the initial workflow runs to complete in the new repository. The
   initial workflow runs will create a pull request to integrate the history
   of the template repository.
3. Merge the pull request to integrate the history of this template into the
   new repository. This allows the new repository to receive upstream changes
   via pull requests whenever a new template release is created.
4. Update [commitlint.config.js](commitlint.config.js) to define the commit
   scopes that you plan to use in the new repository. The `scope-enum` value
   should also include all commit scopes that are used in the template.
5. Update [README.md](README.md) in the new repository:
   - Update the status badges to point to the new repository's workflows. 
   - Describe how the new repository differs from the template.
6. Update the [Makefile](Makefile) and/or
   [integration.yml](.github/workflows/integration.yml) workflow to run tests
   specific to the new repository's purpose. If the new repository is going to
   be a template as well, then you may want to include the existing tests from
   the upstream template.
7. Create a hierarchy of subdirectories with `terragrunt.hcl`, and optional
   `terragrunt.yml` files to describe your configuration. See the
   [examples](examples) directory for inspiration.

## Changelog

All notable changes to this project will be documented in the
[CHANGELOG.md](CHANGELOG.md) file.

## Contributing

See the file [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## License

[MIT License](LICENSE)
