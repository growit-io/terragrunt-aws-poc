# Changelog

### [0.0.4](https://www.github.com/growit-io/template/compare/v0.0.3...v0.0.4) (2021-09-01)


### Bug Fixes

* **template:** always merge with --no-commit --no-ff" to include reverts in merge commit ([fdcd96b](https://www.github.com/growit-io/template/commit/fdcd96b3e0000a0c6fbdeb815d2c2be512ee1c7d))
* **template:** always use original HEAD as PR base, not the current HEAD ([b4562d3](https://www.github.com/growit-io/template/commit/b4562d3d61cb88de17649f4aa7bdaacdafbd74b6))
* **template:** commit with -a to ensure that we include reverted files ([51c0b73](https://www.github.com/growit-io/template/commit/51c0b7351e44590478bc861146e2d3176cbd0b52))
* **template:** maintain one pull request per remote and base branch ([e063985](https://www.github.com/growit-io/template/commit/e063985ea2d40d00441c4d58dc5d33add017506b))
* **template:** retry with "-s recursive -X theirs" if conflicts remain after first merge ([d2d8690](https://www.github.com/growit-io/template/commit/d2d8690bd15ff4374017838ba3613046c8f585ce))


### Automated Tests

* **template:** ensure that histories are related before opening a PR ([465689c](https://www.github.com/growit-io/template/commit/465689c686ecf755af76f0f2a2b8933fd862272d))


### Code Refactoring

* **template:** show command line except for subprocess calls with output=True ([ee42333](https://www.github.com/growit-io/template/commit/ee42333ca28db5f2f60da0b63103fbb850e3dfa1))
* **template:** show command output for fetch and merge ([b73009e](https://www.github.com/growit-io/template/commit/b73009ed3af0788a939425503e351400bd28cee6))
* **template:** suppress remote-merge action output during unit tests ([ddff966](https://www.github.com/growit-io/template/commit/ddff9660b689dc54590d2c8c80421c94dad5751e))

### [0.0.3](https://www.github.com/growit-io/template/compare/v0.0.2...v0.0.3) (2021-08-29)


### Bug Fixes

* **template:** revert merge-exclude paths even in case of unresolvable conflicts ([0dd0458](https://www.github.com/growit-io/template/commit/0dd04586c83482ebe4a1d5c7095734a4bacab04e))


### Build System

* **template:** add Makefile to run unit tests for main.py ([2453c10](https://www.github.com/growit-io/template/commit/2453c100c8fd936175fed99e52ffd6cc6a4d334a))


### CI/CD Workflows

* **template:** run `make test-unit` in integration workflow ([ce1f52c](https://www.github.com/growit-io/template/commit/ce1f52cd002b2915a3e53ec7b8142845984f4c9c))


### Code Refactoring

* **template:** make main.py easier to mock for testing ([df0028b](https://www.github.com/growit-io/template/commit/df0028b8cc89ba2e1037f7a50ff79743632944b6))


### Documentation

* **template:** recommend updating the Makefile and or integration.yml workflow ([c70c5dc](https://www.github.com/growit-io/template/commit/c70c5dc94dd3a615026b56cae22b6d1c71d3edea))
* **template:** use same wording as standard-version to describe CHANGELOG.md ([8e3d07f](https://www.github.com/growit-io/template/commit/8e3d07f7411de58c0866e83299781538f5c5c53c))


### Automated Tests

* **template:** add test for merge-exclude with unresolvable conflicts ([f752ef0](https://www.github.com/growit-io/template/commit/f752ef0fd969984a48fb28fd5d314fbfc64ea73b))
* **template:** test merging of related and unrelated histories ([3ae1c43](https://www.github.com/growit-io/template/commit/3ae1c43d4506d462241b38ce0e4da07d3aa39317))

### [0.0.2](https://www.github.com/growit-io/template/compare/v0.0.1...v0.0.2) (2021-08-28)


### Bug Fixes

* **template:** disable automatic conflict resolution for LICENSE, and README.md ([4c00b92](https://www.github.com/growit-io/template/commit/4c00b92c901dcde08628138869b52fea0cae26d7))
* **template:** maintain a single pull request for upstream changes ([db0a332](https://www.github.com/growit-io/template/commit/db0a332d03421a2bb3d2e43a0eabfe6577a54932))

### [0.0.1](https://www.github.com/growit-io/template/compare/v0.0.0...v0.0.1) (2021-08-28)


### Documentation

* **template:** add status badges for Upstream, Release, and Downstream workflows ([8ed3803](https://www.github.com/growit-io/template/commit/8ed38034bfaea011bd680d52fe5ae45fda294479))
* **template:** replace the summary in README.md with a more detailed description ([d7bc497](https://www.github.com/growit-io/template/commit/d7bc497cc809ae0953eebab3e52b4de828903898))
* **template:** sort feature sections by user relevance ([cbf9a66](https://www.github.com/growit-io/template/commit/cbf9a664fb1d437d8f5825768bedca9c08b40aac))
