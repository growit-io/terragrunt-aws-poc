#!/usr/bin/env python3

import json
import os
import re
import sys
import tempfile

from subprocess import DEVNULL, STDOUT, call, check_call, check_output
from contextlib import contextmanager


@contextmanager
def group(description):
    """Group related output for this workflow with the given description. This
    uses an undocumented feature of GitHub Actions. Output groups can be folded
    and unfolded to hide or show the output in that group. The grouping seems to
    apply to stdout only, at the moment. Anything printed to stderr will not be
    part of the output group.
    """
    try:
        print(f'::group::{description}')
        sys.stdout.flush()
        yield
    finally:
        print('::endgroup::')
        sys.stdout.flush()


def git_status():
    """Return the short-format output of `git status`.

    :returns: whatever `git status --short` prints to stdout
    """
    return check_output(['git', 'status', '--short']).decode()


def git_workdir_is_clean():
    """Ensures that there are no staged changes, no modified files, and no
    untracked files in the current Git working directory.

    :returns: True if the working directory is clean; otherwise, False
    """
    return git_status() == ''


def git_head_is_not_detached():
    """Ensure that the current HEAD is a branch and not a detached commit.

    :returns: True if HEAD is a valid symbolic reference; otherwise, False
    """
    return 0 == call(['git', 'symbolic-ref', 'HEAD'],
                     stdout=DEVNULL, stderr=DEVNULL)


def git_head_branch():
    """Return the name of the currently checked out HEAD branch.

    :returns: short name of the ref that the current HEAD ispointing to
    """
    return check_output(['git', 'symbolic-ref', '--short', 'HEAD']).\
        decode().rstrip()


def git_add_remote(name, url):
    """Add a new Git remote with the specified name and repository URL."""
    check_call(['git', 'remote', 'add', name, url])


def git_fetch_branches_and_tags(remote):
    """Fetch branches and tags for the specified remote. The tags are fetched
    into 'refs/tags/{remote}/*' where '{remote}' is the specified remote. This
    allows us to keep local tags unmodified and run `git merge {remote}/{tag}`
    to merge either a remote branch or tag.
    """
    check_call(['git', 'fetch', '--no-tags', '--prune', remote,
                f'+refs/heads/*:refs/remotes/{remote}/*',
                f'+refs/tags/*:refs/tags/{remote}/*'], stderr=STDOUT)


def git_merge_no_commit(strategy, ref):
    """Merge the given ref into the current HEAD, but do not commit the result.
    If there are any conflicts, they need to be resolved before committing the
    result of the merge.

    :param: strategy: valid value for the `-s <strategy>` option of `git merge`
    :param: ref: valid Git ref, but should be a remote branch or tag in our case

    :returns: True if the merge operation was successful or the HEAD branch is
    already up to date, and False if there were conflicts or other reasons that
    prevented the merge operation.
    """
    return 0 == call(['git', 'merge', '-s', strategy, '--no-commit',
                      '--allow-unrelated-histories', ref], stderr=STDOUT)


def git_unmerged_paths(status):
    """Assuming that a merge conflict has occurred, return the list of paths
    that still have an unresolved merge conflict. This will also include any
    paths that are untracked, as in our workflow there should be no untracked
    files in the working directory.

    :returns: list of paths that still have a merge conflict, or are untracked

    Examples:

    Untracked paths in the working directory will be returned as unmerged:
    >>> git_unmerged_paths('?? foo\\n')
    ['foo']

    Already staged paths without conflicts will not be returned:
    >>> git_unmerged_paths(' A foo\\n')
    []

    Renamed/copied unmerged paths will be returned as the destination path:
    >>> git_unmerged_paths('MM orig -> foo\\n')
    ['foo']

    An actual example from this project:
    >>> git_unmerged_paths('A  .github/workflows/generate.yml\\n'
    ...                    'AA .github/workflows/downstream.yml\\n'
    ...                    'AA .github/workflows/release.yml\\n'
    ...                    'AA .github/workflows/upstream.yml\\n'
    ...                    'AA CHANGELOG.md\\n'
    ...                    'AA version.txt\\n')
    ['.github/workflows/downstream.yml', '.github/workflows/release.yml', '.github/workflows/upstream.yml', 'CHANGELOG.md', 'version.txt']
    """
    paths = []

    for line in status.rstrip('\n').split('\n'):
        m = re.match('^[^ ][^ ] ([^ ]+ -> )?([^ ]+)', line)
        if m:
            paths.append(m[2])

    return paths


def revert_excluded_paths(exclude_patterns):
    """Reverts all files matched by the given exclude patterns to their state
    on the HEAD branch.

    :param exclude_patterns: content of a gitignore(5) file
    """
    for path in git_ls_files_ignored(exclude_patterns):
        print(f'Excluding {path} from merge')

        check_call(['git', 'reset', '-q', '--', path])

        if 0 != call(['git', 'checkout', '-q', 'HEAD', '--', path],
                     stderr=DEVNULL):
            os.unlink(path)


def git_ls_files_ignored(exclude_patterns):
    """List all paths in the index matching patterns in the given gitignore(5)
    style wildcard patterns.

    :param exclude_patterns: content of a gitignore(5) file
    :returns: list of indexed paths matching the exclude patterns
    """
    with tempfile.NamedTemporaryFile() as exclude:
        with open(exclude.name, 'w') as f:
            f.write(exclude_patterns)
            f.close()

        output = check_output([
            'git', 'ls-files', '--cached', '--ignored',
            f'--exclude-from={exclude.name}'
        ]).decode().rstrip('\n')

        if output == '':
            return []

        return output.split('\n')


def resolve_all_merge_conflicts(conflict_resolution):
    """Attempt to resolve all merge conflicts that are present in the current
    working directory.

    :returns: True if all conflicts have been resolved; otherwise, False if
    there would still be conflicts remaining after applying all actions
    """
    unmerged_paths = set(git_unmerged_paths(git_status()))
    remaining_unmerged_paths = unmerged_paths - set(conflict_resolution.keys())

    if remaining_unmerged_paths:
        print('Cannot resolve all merge conflicts automatically.')
        print('The following paths would remain unmerged after conflict '
              'resolution:\n\n' + '\n'.join(remaining_unmerged_paths))
        return False

    conflict_resolution_actions = {
        'ours': git_revert_to_head
    }

    for path in unmerged_paths:
        action = conflict_resolution[path]

        if action in conflict_resolution_actions:
            conflict_resolution_actions[action](path)
        else:
            valid_actions = conflict_resolution_actions.keys()
            raise ValueError(f'invalid conflict resolution action "{action}"'
                             f' for {path}: must be one of: {valid_actions}')

    return True


def git_revert_to_head(path):
    """Revert the given path to its state on the HEAD branch."""
    git_reset_and_checkout('HEAD', path)


def git_reset_and_checkout(tree_ish, path):
    """Remove the given path from the index and restore the contents of the
    path from the current HEAD branch. If the path does not exist on the HEAD
    branch, then it will be removed from the working directory.
    """
    print(f'Reverting {path} to {tree_ish}')
    check_call(['git', 'reset', '-q', '--', path])
    check_call(['git', 'checkout', '-q', tree_ish, '--', path])


def git_rev_parse(ref):
    """Return the commit sha of the given ref."""
    return check_output(['git', 'rev-parse', ref]).decode().rstrip()


def git_merge_in_progress():
    """Returns whether a merge operation is on progress, or not.
    """
    toplevel = check_output(['git', 'rev-parse', '--show-toplevel']).decode().rstrip()
    return os.path.isfile(os.path.join(toplevel, '.git', 'MERGE_HEAD'))


def git_commit(message):
    """Commit all changes in the working directory with the specified message.

    :returns: True if the commit was successfully created, and False if there
    was any reason that prevented the commit operation.
    """
    check_call(['git', 'commit', '-m', message], stderr=STDOUT)


def git_force_push(ref, branch):
    """Force-push the given ref to the given branch."""
    check_call(['git', 'push', '-f', 'origin', f'{ref}:refs/heads/{branch}'])


def git_delete_remote_branch(branch):
    """Delete the given branch in the remote Git repository.
    """
    check_call(['git', 'push', 'origin', f':refs/heads/{branch}'])


def github_create_or_update_pull_request(head, base, title, body):
    """Create or update a pull request to merge the given head into the given
    base.
    """
    # TODO: check if the pull request exists rather than blindly creating one
    # TODO: avoid having to grant 'read:org' and 'read:discussion' to token

    if 0 == call(['gh', 'pr', 'create', '-B', base, '-H', head, '-t', title,
                  '-b', body], stderr=STDOUT):
        return 0

    print('Creating pull request failed. Attempting to edit the existing one.')

    # This command requires 'read:org' and 'read:discussion' scopes, which is
    # more than we would need if we used the API directly.
    check_call(['gh', 'pr', 'edit', '-B', base, '-t', title, '-b', body, head],
               stderr=STDOUT)


def github_template_repository():
    """Return the repository that the current one was created from."""
    info = json.loads(
        check_output(['gh', 'repo', 'view', '--json', 'templateRepository'])
    )['templateRepository']

    return info['owner']['login'] + '/' + info['name']


def main():
    """Gather the inputs for this GitHub Action and merge the specified branch
    or tag of the specified remote repository into the current HEAD. The current
    HEAD is assumed to point to a branch (not a detached commit) and the working
    directory must be clean before this action.

    :returns: 0 on success, or an integer greater than 0 on failure
    """
    # As a sanity check, ensure that the working directory is clean before we
    # start, and that the current HEAD is not a detached commit, so that other
    # Git operations can work on these assumptions.
    assert git_workdir_is_clean()
    assert git_head_is_not_detached()

    # Gather automatic action environment variables and derived values
    github_api_url = os.environ['GITHUB_API_URL']
    github_url = github_api_url.replace('api.', '').replace('/api', '')
    github_host = re.sub('.*://', '', github_url)
    github_actor = os.environ['GITHUB_ACTOR']

    # Set required environment variables for the GitHub CLI
    token = os.environ['TOKEN']
    os.environ['GITHUB_TOKEN'] = token

    # Gather the remaining action inputs and assume defaults
    clone_token = os.environ['CLONE_TOKEN'] or token
    repository = os.environ['REPOSITORY'] or github_template_repository()
    assert re.match('.+/.+', repository)
    repository_name = repository.split('/')[1]
    repository_url = f'{github_url}/{repository}'
    branch_or_tag = os.environ['BRANCH_OR_TAG'] or git_head_branch()
    merge_strategy = os.environ['MERGE_STRATEGY']
    merge_exclude = os.environ['MERGE_EXCLUDE']
    conflict_resolution = json.loads(os.environ['CONFLICT_RESOLUTION'])
    remote = os.environ['REMOTE'] or repository_name
    clone_url = f'https://x-github-token:{clone_token}@{github_host}/{repository}.git'
    remote_ref = f'{remote}/{branch_or_tag}'
    pr_branch = os.environ['PR_BRANCH'] or \
        f'chore/merge-{repository_name}-{branch_or_tag}'
    delete_pr_branch = os.environ['DELETE_PR_BRANCH'] == 'true'

    # Set environment variables required for Git merge and commit operations
    if 'GIT_AUTHOR_NAME' not in os.environ:
        os.environ['GIT_AUTHOR_NAME'] = github_actor
    if 'GIT_AUTHOR_EMAIL' not in os.environ:
        os.environ['GIT_AUTHOR_EMAIL'] = f'{github_actor}@users.noreply.github.com'
    if 'GIT_COMMITTER_NAME' not in os.environ:
        os.environ['GIT_COMMITTER_NAME'] = os.environ['GIT_AUTHOR_NAME']
    if 'GIT_COMMITTER_EMAIL' not in os.environ:
        os.environ['GIT_COMMITTER_EMAIL'] = os.environ['GIT_AUTHOR_EMAIL']

    with group(f'Prepare the {remote} remote'):
        git_add_remote(remote, clone_url)
        git_fetch_branches_and_tags(remote)

    push_ref = 'HEAD'

    with group(f'Merge {remote_ref} into {git_head_branch()}'):
        merge_success = git_merge_no_commit(merge_strategy, f'{remote_ref}')

        if git_merge_in_progress():
            revert_excluded_paths(merge_exclude)

        if not merge_success:
            if not resolve_all_merge_conflicts(conflict_resolution):
                push_ref = git_rev_parse(remote_ref)

    # Prepare the commit summary and pull request title
    scope = os.path.basename(os.getcwd())
    description = f'merge {repository}@{branch_or_tag}'
    summary = f'chore({scope}): {description}'

    if push_ref == 'HEAD':
        with group(f'Commit changes to {git_head_branch()}'):
            if not git_merge_in_progress():
                print('Nothing to commit, working tree clean.')

                if delete_pr_branch:
                    git_delete_remote_branch(pr_branch)

                return 0

            git_commit(summary)

    with group(f'Push {push_ref} to {pr_branch}'):
        git_force_push(push_ref, pr_branch)

    with group(f'Create pull request for {pr_branch}'):
        github_create_or_update_pull_request(
            base=git_head_branch(),
            head=pr_branch,
            title=summary,
            body=f'This change integrates all commits from **{branch_or_tag}** '
                 f'in the [{repository}]({repository_url}) repository.'
        )

    return 0


if __name__ == '__main__':
    import doctest
    doctest.testmod()
