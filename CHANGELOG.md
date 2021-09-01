# Changelog

### [0.0.3](https://www.github.com/growit-io/terragrunt-aws-poc/compare/v0.0.2...v0.0.3) (2021-09-01)


### CI/CD Workflows

* **terragrunt-aws-poc:** ensure related histories when creating a PR ([7a2cde3](https://www.github.com/growit-io/terragrunt-aws-poc/commit/7a2cde36e4da3c1a3ba1833a8a3ab4919dafaf68))

### [0.0.2](https://www.github.com/growit-io/terragrunt-aws-poc/compare/v0.0.1...v0.0.2) (2021-08-29)


### Bug Fixes

* **template:** revert merge-exclude paths even in case of unresolvable conflicts ([0dd0458](https://www.github.com/growit-io/terragrunt-aws-poc/commit/0dd04586c83482ebe4a1d5c7095734a4bacab04e))


### Build System

* **template:** add Makefile to run unit tests for main.py ([2453c10](https://www.github.com/growit-io/terragrunt-aws-poc/commit/2453c100c8fd936175fed99e52ffd6cc6a4d334a))


### CI/CD Workflows

* **template:** run `make test-unit` in integration workflow ([ce1f52c](https://www.github.com/growit-io/terragrunt-aws-poc/commit/ce1f52cd002b2915a3e53ec7b8142845984f4c9c))


### Code Refactoring

* **template:** make main.py easier to mock for testing ([df0028b](https://www.github.com/growit-io/terragrunt-aws-poc/commit/df0028b8cc89ba2e1037f7a50ff79743632944b6))


### Documentation

* **template:** recommend updating the Makefile and or integration.yml workflow ([c70c5dc](https://www.github.com/growit-io/terragrunt-aws-poc/commit/c70c5dc94dd3a615026b56cae22b6d1c71d3edea))
* **template:** use same wording as standard-version to describe CHANGELOG.md ([8e3d07f](https://www.github.com/growit-io/terragrunt-aws-poc/commit/8e3d07f7411de58c0866e83299781538f5c5c53c))
* **terragrunt-aws:** update status badges to point to the correct repository ([60eb8cb](https://www.github.com/growit-io/terragrunt-aws-poc/commit/60eb8cb5d8e5f51028167c638c10f460d243c463))


### Automated Tests

* **template:** add test for merge-exclude with unresolvable conflicts ([f752ef0](https://www.github.com/growit-io/terragrunt-aws-poc/commit/f752ef0fd969984a48fb28fd5d314fbfc64ea73b))
* **template:** test merging of related and unrelated histories ([3ae1c43](https://www.github.com/growit-io/terragrunt-aws-poc/commit/3ae1c43d4506d462241b38ce0e4da07d3aa39317))

### [0.0.1](https://www.github.com/growit-io/terragrunt-aws-poc/compare/v0.0.0...v0.0.1) (2021-08-29)


### Bug Fixes

* **template:** disable automatic conflict resolution for LICENSE, and README.md ([4c00b92](https://www.github.com/growit-io/terragrunt-aws-poc/commit/4c00b92c901dcde08628138869b52fea0cae26d7))
* **template:** maintain a single pull request for upstream changes ([db0a332](https://www.github.com/growit-io/terragrunt-aws-poc/commit/db0a332d03421a2bb3d2e43a0eabfe6577a54932))
* **terragrunt-aws:** use correct the `layer` attribute in aws/terragrunt.yml ([6d78eab](https://www.github.com/growit-io/terragrunt-aws-poc/commit/6d78eabfe897812765684029df2b29779e5a787b))


### Code Refactoring

* **terragrunt-aws:** rename root-layer input to `cloud` and update example ([4148593](https://www.github.com/growit-io/terragrunt-aws-poc/commit/4148593f603685ea873c27512d2ab3b08423c36d))


### Documentation

* **template:** add status badges for Upstream, Release, and Downstream workflows ([8ed3803](https://www.github.com/growit-io/terragrunt-aws-poc/commit/8ed38034bfaea011bd680d52fe5ae45fda294479))
* **template:** replace the summary in README.md with a more detailed description ([d7bc497](https://www.github.com/growit-io/terragrunt-aws-poc/commit/d7bc497cc809ae0953eebab3e52b4de828903898))
* **template:** sort feature sections by user relevance ([cbf9a66](https://www.github.com/growit-io/terragrunt-aws-poc/commit/cbf9a664fb1d437d8f5825768bedca9c08b40aac))
* **terragrunt-aws-poc:** integrate upstream changes and usage in README.md ([4765ba9](https://www.github.com/growit-io/terragrunt-aws-poc/commit/4765ba922211a4419d50f475d7097137a6136461))
* **terragrunt-aws:** integrate upstream changes and describe subdirectories ([3688ded](https://www.github.com/growit-io/terragrunt-aws-poc/commit/3688ded4bccb9ec805743ca7458f653e27f250ac))
