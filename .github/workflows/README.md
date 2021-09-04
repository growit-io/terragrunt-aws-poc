# GitHub Workflows

- [**Integration**](integration.yml): Validates all commit messages using
  `commitlint` and creates Terraform execution plans for all non-production
  configurations.
- [**Release**](release.yml): Maintains a changelog, release tags, and releases
  on GitHub and applies changes in either non-production, or production
  configurations, depending on whether a release was created.
- [**Upstream**](upstream.yml): Keeps this repository synchronized with the
  template that generated it. This workflow is triggered automatically whenever
  a new release of the template is created.
- [**Downstream**](downstream.yml): If this repository was used as a template to
  generate other repositories, this workflow will notify the generated
  repositories of new releases created in this repository.
