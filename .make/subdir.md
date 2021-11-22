# subdir.mk

The `subdir.mk` fragment includes [`help.mk`](help.md) and enables recursive
processing of Makefiles in subdirectories. The list of immediate subdirectories
to traverse is specified via the **SUBDIRS** variable, which defaults to all
subdirectories that also contain a `Makefile` file.

At least the top-level `Makefile` in this repository, as well as any `Makefile`
for a collection of Terraform modules or Terraform module examples should
include this fragment.

## Variables

### DEFAULT_GOAL

Specifies the goal which should be assumed when no goal has been provided on
the command-line. If unset, the first goal defined will be used as the default
goal, which would conventionally be the goal named `all`.

Default: None

### GIT

The command to execute in order to invoke Git when checking whether a
subdirectory contains changes.

Default: `git`

### GIT_BASE_REF

The base reference to compare against when determining whether a subdirectory
contains changes.

Default: `origin/main`

### SUBDIRS

The list of subdirectories to recurse into. It may be useful to override this
variable when you want to recurse only into specific directories and exclude all
others, even though they might contain a `Makefile`.

Default: All subdirectories which contain a `Makefile` file

### EXCLUDE_SUBDIRS

A list of subdirectories to exclude from **SUBDIRS** when traversing
subdirectories for recursive goals.

Default: None

### SKIP_UNCHANGED

Whether to ignore subdirectories for which Git reports no changes either in the
working tree, the index of staged changes, or the current HEAD branch when
compared against the base reference as defined by **GIT_BASE_REF**.

Default: `false`; can be set to `true`

## Goals

### all, lint, fix, test, clean

These goals have no steps associated with them, by default, but they will
trigger recursion into subdirectories defined in the **SUBDIRS** variable,
except for those also listed in **EXCLUDE_SUBDIRS**. Recursion can also be
restricted to subdirectories which contain changes compared to **GIT_BASE_REF**
by setting the **SKIP_UNCHANGED** variable to `true`.
