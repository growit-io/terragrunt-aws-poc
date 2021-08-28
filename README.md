# Template
> Repository template with GitHub workflows

## Features

### GitHub actions

- [**Remote Merge**](.github/actions/remote-merge): Merges the history of a
  branch or tag in another repository into this repository.

### GitHub workflows

- [**Integration**](.github/workflows/integration.yml): Validates all commit
  messages using `commitlint`.
- [**Release**](.github/workflows/release.yml): Maintains a changelog, release
  tags, and releases on GitHub.
- [**Downstream**](.github/workflows/downstream.yml): Notifies repositories
  created from this template of new releases.
- [**Upstream**](.github/workflows/upstream.yml): Keeps this repository
  synchronized with the template that it was created from.

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
5. Update [README.md](README.md) to describe how the new repository differs
   from the template.

## Changelog

All relevant changes to this project are documented in the file
[CHANGELOG.md](CHANGELOG.md).

## Contributing

See the file [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## License

[MIT License](LICENSE)
