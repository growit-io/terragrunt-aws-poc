# help.mk

The `help.mk` fragment extracts a one-line description for each goal from each
loaded Makefile fragment and generates a **help** goal to print the summary of
all available and documented goals.

## Variables

### AWK

The command to execute in order to invoke the Awk text processing tool.

Default: `awk`

## Goals

### help

Prints a summary table with the names of all available and documented goals
in the loaded Makefile fragments and a one-line description for each goal that
is extracted directly from the Makefile fragment source.

## References

- [macos - How to automatically generate a Makefile help command - Stack Overflow](https://stackoverflow.com/questions/35730218/how-to-automatically-generate-a-makefile-help-command)
