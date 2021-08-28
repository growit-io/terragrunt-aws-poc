const Configuration = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'scope-empty': [2, 'never'],
    'scope-enum': [2, 'always', [
      'template',
      'terragrunt',
      'terragrunt-aws',
      'terragrunt-aws-poc',
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
