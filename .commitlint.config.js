const Configuration = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'body-max-line-length': [0, 'always', 100],
    'scope-empty': [2, 'never'],
    'scope-enum': [2, 'always', [
      'template',
      'terragrunt',
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
