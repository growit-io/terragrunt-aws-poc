# Changelog

## [0.1.0](https://www.github.com/growit-io/terragrunt-aws-poc/compare/v0.0.2...v0.1.0) (2021-09-03)


### Features

* **terragrunt:** provide defaults for the "gcs" backend config ([6efb475](https://www.github.com/growit-io/terragrunt-aws-poc/commit/6efb47599274cdb4ccd70c83665c7e1e2fe7a072))
* **terragrunt:** support loading terragrunt.yml from the configuration directory itself as well ([bab92ee](https://www.github.com/growit-io/terragrunt-aws-poc/commit/bab92eed08ca8f5a8a7b92d22e91af3297f0656c))


### Bug Fixes

* **template:** always merge with --no-commit --no-ff" to include reverts in merge commit ([fdcd96b](https://www.github.com/growit-io/terragrunt-aws-poc/commit/fdcd96b3e0000a0c6fbdeb815d2c2be512ee1c7d))
* **template:** always use original HEAD as PR base, not the current HEAD ([b4562d3](https://www.github.com/growit-io/terragrunt-aws-poc/commit/b4562d3d61cb88de17649f4aa7bdaacdafbd74b6))
* **template:** commit with -a to ensure that we include reverted files ([51c0b73](https://www.github.com/growit-io/terragrunt-aws-poc/commit/51c0b7351e44590478bc861146e2d3176cbd0b52))
* **template:** maintain one pull request per remote and base branch ([e063985](https://www.github.com/growit-io/terragrunt-aws-poc/commit/e063985ea2d40d00441c4d58dc5d33add017506b))
* **template:** retry with "-s recursive -X theirs" if conflicts remain after first merge ([d2d8690](https://www.github.com/growit-io/terragrunt-aws-poc/commit/d2d8690bd15ff4374017838ba3613046c8f585ce))
* **terragrunt:** run fix-backend-config hook only for the s3 backend ([94795d9](https://www.github.com/growit-io/terragrunt-aws-poc/commit/94795d98556398a7bc0e897b34185576a6989301))


### Automated Tests

* **template:** ensure that histories are related before opening a PR ([465689c](https://www.github.com/growit-io/terragrunt-aws-poc/commit/465689c686ecf755af76f0f2a2b8933fd862272d))


### Build System

* **terragrunt:** add `fmt-check` target to Makefile ([ceb7cea](https://www.github.com/growit-io/terragrunt-aws-poc/commit/ceb7cea0917ae3a559656ec2a846cbedee687fa4))
* **terragrunt:** add `fmt-fix` target to Makefile ([f664ed4](https://www.github.com/growit-io/terragrunt-aws-poc/commit/f664ed48df4cfb41c5f964aac9a1632643aec152))
* **terragrunt:** add `set -e` to every multi-command target in Makefile ([9d6b063](https://www.github.com/growit-io/terragrunt-aws-poc/commit/9d6b063f036933868720ace76ce2fc7ae50ffec5))
* **terragrunt:** add `tflint` target to Makefile ([f9d20e7](https://www.github.com/growit-io/terragrunt-aws-poc/commit/f9d20e7ba54226493c2ad6ca144c1e7f8df69d49))
* **terragrunt:** add examples/remote-state/states/terraform.tfstate ([383af47](https://www.github.com/growit-io/terragrunt-aws-poc/commit/383af47cd8e7147eddb31b85e75a60da6561e0b7))
* **terragrunt:** generate graphs in Terragrunt configuration directories with or without README.md ([1494446](https://www.github.com/growit-io/terragrunt-aws-poc/commit/1494446f7cf65e7bea3564f8ccc54c29e9281d93))
* **terragrunt:** include `fmt-check` and `tflint` in default targets ([802909b](https://www.github.com/growit-io/terragrunt-aws-poc/commit/802909b693c3eae1a660d13cae5d99d9a04943b0))
* **terragrunt:** remove .terraform directories with `make clean` ([987263c](https://www.github.com/growit-io/terragrunt-aws-poc/commit/987263cfc3ad68d5aeeeee8d3e26ff74233b51a6))
* **terragrunt:** set default configuration paths to `*` in Makefile ([291008a](https://www.github.com/growit-io/terragrunt-aws-poc/commit/291008a007027005528f326bd145ccb655f10cc1))


### Documentation

* **terragrunt:** add basic example for `remote_state.backend: terragrunt` ([00858f7](https://www.github.com/growit-io/terragrunt-aws-poc/commit/00858f7ffc11dc4b9a8e5c6b964809dc197ecb88))
* **terragrunt:** demonstrate default `key` attribute for terragrunt backend config ([78d04b6](https://www.github.com/growit-io/terragrunt-aws-poc/commit/78d04b635108a46cef3ab7ccd1e7118321624bab))
* **terragrunt:** include graph.svg in toplevel README.md ([24a50da](https://www.github.com/growit-io/terragrunt-aws-poc/commit/24a50da8092f859f0d342ea4e17bd254b5c548f7))
* **terragrunt:** show parent terragrunt.hcl file in dependency graphs ([c7d388f](https://www.github.com/growit-io/terragrunt-aws-poc/commit/c7d388fc23ea4e71003955696ac4c830c325a3b6))


### Code Refactoring

* **template:** show command line except for subprocess calls with output=True ([ee42333](https://www.github.com/growit-io/terragrunt-aws-poc/commit/ee42333ca28db5f2f60da0b63103fbb850e3dfa1))
* **template:** show command output for fetch and merge ([b73009e](https://www.github.com/growit-io/terragrunt-aws-poc/commit/b73009ed3af0788a939425503e351400bd28cee6))
* **template:** suppress remote-merge action output during unit tests ([ddff966](https://www.github.com/growit-io/terragrunt-aws-poc/commit/ddff9660b689dc54590d2c8c80421c94dad5751e))
* **terragrunt-aws-poc:** document all module variables and outputs ([092a623](https://www.github.com/growit-io/terragrunt-aws-poc/commit/092a6236eed934a014a0c4ea5b5fa9ff2f147dad))
* **terragrunt-aws-poc:** fix variable type definitions for access and identity root modules ([8632bb8](https://www.github.com/growit-io/terragrunt-aws-poc/commit/8632bb8d1700fd90b82bcb52e504c2d5ab9ac8c5))
* **terragrunt:** make the parent terragrunt.hcl easier to understand and maintain ([d3357d3](https://www.github.com/growit-io/terragrunt-aws-poc/commit/d3357d3660ad4d8e69ca1d460db7512d16e79d65))
* **terragrunt:** move scripts called from Makefile to `.terragrunt/bin` directory ([2584ca1](https://www.github.com/growit-io/terragrunt-aws-poc/commit/2584ca14e8768e7070647dd68f1a95a7ba92c457))
* **terragrunt:** rename `.terragrunt/null` directory to `.terragrunt/mock` ([07a44a1](https://www.github.com/growit-io/terragrunt-aws-poc/commit/07a44a1472cac8f47c277988071bb5b1aae9b0a5))
* **terragrunt:** update file comment block in parent terragrunt.hcl ([a6c6b28](https://www.github.com/growit-io/terragrunt-aws-poc/commit/a6c6b289f16ff3b8994954b429d88970d0bc4b3d))


### CI/CD Workflows

* **terragrunt-aws-poc:** create execution plans for production on every pull request ([fa98da4](https://www.github.com/growit-io/terragrunt-aws-poc/commit/fa98da4a619d3ed935cfb1403ab288a483349638))
* **terragrunt-aws-poc:** ensure related histories when creating a PR ([7a2cde3](https://www.github.com/growit-io/terragrunt-aws-poc/commit/7a2cde36e4da3c1a3ba1833a8a3ab4919dafaf68))
* **terragrunt-aws:** ensure that histories are related before opening a PR ([6de88e7](https://www.github.com/growit-io/terragrunt-aws-poc/commit/6de88e7bd2e9f8c0ccc3fa54d1910e8b7f7a3c25))
* **terragrunt:** add `fmt-check` job to integration.yml workflow ([b29c176](https://www.github.com/growit-io/terragrunt-aws-poc/commit/b29c17639e6a7449eb5feb8ec4a5928cc4e8ede9))
* **terragrunt:** add `terraform-docs` step to release.yml workflow ([a4ba1b0](https://www.github.com/growit-io/terragrunt-aws-poc/commit/a4ba1b0badaa699263a85b0e190ae21fc299b215))
* **terragrunt:** add `terragrunt` and `feedback` actions to integration and release workflows ([4ac7bc1](https://www.github.com/growit-io/terragrunt-aws-poc/commit/4ac7bc1396b35a0cd14a52b49e6a628541e07488))
* **terragrunt:** add `tflint` job to integration.yml workflow ([a4cd33e](https://www.github.com/growit-io/terragrunt-aws-poc/commit/a4cd33e02eb6be79ef2eaaa53486fc589fe75b92))
* **terragrunt:** apply examples/remote-state/states config before graph as well ([3b1b44d](https://www.github.com/growit-io/terragrunt-aws-poc/commit/3b1b44daa86376e343f9f8a410d41b533c91afe2))
* **terragrunt:** apply examples/remote-state/states config before plan or apply ([0e07499](https://www.github.com/growit-io/terragrunt-aws-poc/commit/0e074995fe195307cf210a6c43c2f72f280ea28c))
* **terragrunt:** fix permission issues after running `terragrunt-docs` ([dee5b43](https://www.github.com/growit-io/terragrunt-aws-poc/commit/dee5b43134f2bff073f9cd5308524f479f9f042d))
* **terragrunt:** install tfenv/tgenv only once per workflow job ([9212052](https://www.github.com/growit-io/terragrunt-aws-poc/commit/92120527ab467d207a7a5c8d7d45e2b1e0b5013d))
* **terragrunt:** remove "Create necessary states" step from CI/CD workflows ([0b6ed1f](https://www.github.com/growit-io/terragrunt-aws-poc/commit/0b6ed1f9e61ee7b11e928a99bb785651fbe65768))
* **terragrunt:** remove unit-test from integration workflow and Makefile ([f0ab1b9](https://www.github.com/growit-io/terragrunt-aws-poc/commit/f0ab1b9d559b30570427eea8ac2674259d956b4d))

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
