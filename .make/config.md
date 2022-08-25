# config.mk

The `config.mk` fragment sources a user-defined Makefile fragment, if it exists,
and ensures that common variables required by other fragments are defined.

## Variables

### USER_CONFIG

The path to a user-defined Makefile fragment to load in order to provide values
for all required variables.

Default: `$(HOME)/.config/terragrunt.mk`
