const Configuration = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'body-max-line-length': [0, 'always', 100],
    'scope-empty': [2, 'never'],
    'scope-enum': [2, 'always', [
      /*
       * This scope marks changes from the upstream "template" repository
       * at https://github.com/growit-io/template.
       */
      'template',
      /*
       * This scope marks changes from the template repository "terragrunt"
       * at https://github.com/growit-io/template, whenever there is not a
       * more specific scope given in that change. See below for additional,
       * specific scopes introduced in the "terragrunt" template repository.
       */
      'terragrunt',
      /*
       * This scope identifies Amazon Web Services-specific adjustments in
       * the "terragrunt-aws" template repository.
       */
      'terragrunt-aws',
      /*
       * Changes affecting the CI/CD actions and workflows defined in the
       * .github/ directory within this repository. Often, but not always,
       * the commit type associated with these changes would be "ci".
       */
      'github',
      /*
       * Changes affecting the commitlint configuration in this repository.
       */
      'commitlint',
      /*
       * Changes affecting the makefile files or fragments in this repository.
       */
      'make',
    ]],
    'type-enum': [2, 'always', [
      'feat',
      'fix',
      'perf',
      'refactor',
      'style',
      'build',
      'test',
      'ci',
      'docs',
      'chore',
    ]]
  },
}

module.exports = Configuration;
