# GitHub Workflows

- [**Integration**](integration.yml): Validates pull requests using
  [commitlint](https://github.com/conventional-changelog/commitlint),
  [TFLint](https://github.com/terraform-linters/tflint),
  and [`make fmt-check`](../../Makefile), creates Terraform execution plans to
  preview changes, and provides a feedback comment with a summary of the changed
  configuration paths.
- [**Release**](release.yml): Maintains a changelog, release tags, and releases
  on GitHub and applies changes in either non-production, or production
  configurations, depending on whether a release was created. It also runs a job
  which generates dependency graphs for all Terragrunt configurations, and usage
  details for all Terraform modules.
- [**Upstream**](upstream.yml): Keeps this repository synchronized with the
  template that generated it. This workflow is triggered automatically whenever
  a new release of the template is created.
- [**Downstream**](downstream.yml): If this repository was used as a template to
  generate other repositories, this workflow will notify the generated
  repositories of new releases created in this repository.
