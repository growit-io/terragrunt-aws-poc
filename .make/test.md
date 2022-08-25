# test.mk

The `test.mk` fragment includes [`config.mk`](config.md) and defines goals
which execute Go test suites in order to perform additional verification steps
on the existing examples of a Terraform module using the [Terratest][terratest]
library.

This fragment should be included in the `test/Makefile` file of any Terraform
module which provides additional test suites on top of working examples.

[terratest]: https://github.com/gruntwork-io/terratest

## Variables

### EXAMPLES

The list of example subdirectories to enter when the **clean** goal is invoked.

Default: All subdirectories of the directory specified by **EXAMPLES_DIR**

### EXAMPLES_DIR

The path to the directory that contains the working examples that the test
suites are based on.

Default: `../examples`

### GO

The command to execute in order to invoke the compiler and other Go language
tools.

Default: `go`

### GO_TEST_TIMEOUT

The value of the `-timeout` option to pass to `go test`. This value should be in
a format that is recognized by the [time](https://pkg.go.dev/time#ParseDuration)
package, and it should be significantly larger than the average duration needed
to execute all test suites for the module. The reason for this is explained in
the [Terratest documentation](https://terratest.gruntwork.io/docs/testing-best-practices/timeouts-and-logging/).

Default: `30m`

## Goals

### all

This is the default goal and an alias for the **test** goal.

### test

This goal first evaluates the **depends** goal, then runs the test suites
using `go test`, and finally invokes the **clean** target to leave the working
tree in a clean state.

### depends

This goal downloads the [terratest][terratest] Go library and other dependencies
for the test suites using `go mod download`.

### clean

Invokes the **clean** target for all example scenarios defined in **EXAMPLES**.
