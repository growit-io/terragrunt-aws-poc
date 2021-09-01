import contextlib
import os
import subprocess
import tempfile
import unittest

from unittest.mock import patch

import main

# Disable all subprocess output during unit tests.
main.quiet = True


@contextlib.contextmanager
def cwd(path):
    owd = os.getcwd()
    try:
        os.chdir(path)
        yield
    finally:
        os.chdir(owd)


@contextlib.contextmanager
def environ(overrides):
    old_environ = os.environ.copy()
    try:
        os.environ.update(overrides)
        yield
    finally:
        os.environ.clear()
        os.environ.update(old_environ)


@contextlib.contextmanager
def fake_github_action_environ():
    with environ({
        # Required automatic variables normally provided by GitHub Actions
        'GITHUB_API_URL': 'https://api.github.com',
        'GITHUB_ACTOR': 'github-actions-bot',

        # Required input variables for this action
        'TOKEN': '',
        'CLONE_TOKEN': '',
        'REPOSITORY': 'owner/upstream',
        'BRANCH_OR_TAG': '',
        'MERGE_STRATEGY': 'recursive',
        'MERGE_EXCLUDE': '',
        'CONFLICT_RESOLUTION': '{}',
        'REMOTE': '',
        'PR_BRANCH': '',
        'DELETE_PR_BRANCH': 'true',

        # This ensures that we can't use SSH or HTTPS for cloning and makes
        # sure that any value present in the test environment is ignored.
        'GIT_ALLOW_PROTOCOL': 'file',

        # These need to be set for commits to work outside of main.main().
        'GIT_AUTHOR_NAME': 'test',
        'GIT_AUTHOR_EMAIL': 'test@example.com',
        'GIT_COMMITTER_NAME': 'test',
        'GIT_COMMITTER_EMAIL': 'test@example.com',
    }):
        yield


class GitRepository(object):
    def __init__(self, work_tree):
        self.work_tree = work_tree

    def write_file(self, filename, content):
        with open(f'{self.work_tree}/{filename}', 'w') as f:
            f.write(content)

    def git_commit(self, *args, message='automated commit'):
        self.git('commit', '-m', message, *args)

    def git(self, *args, output=False):
        with cwd(self.work_tree):
            cmd = ['git'] + list(args)
            stdout = subprocess.DEVNULL
            stderr = subprocess.DEVNULL

            if output:
                return subprocess.check_output(cmd, stderr=stderr).decode()
            else:
                subprocess.check_call(cmd, stdout=stdout, stderr=stderr)
                return None


@contextlib.contextmanager
def temporary_git_repository():
    with tempfile.TemporaryDirectory() as work_tree:
        repository = GitRepository(work_tree)
        repository.git('init')

        yield repository


class TestMain(unittest.TestCase):

    def test_merge_equal_unrelated_histories(self):
        self.remote.write_file('README.md', '# Test')
        self.remote.git('add', 'README.md')
        self.remote.git_commit('--allow-empty')

        self.local.write_file('README.md', '# Test')
        self.local.git('add', 'README.md')
        self.local.git_commit('--allow-empty')

        self.assertEqual(main.main(), 0)

        self.assertFalse(self.git_force_push.called)
        self.assertTrue(self.git_delete_remote_branch.called)
        self.assertFalse(self.github_create_or_update_pull_request.called)

    def test_merge_unrelated_histories_with_conflict(self):
        self.remote.write_file('README.md', '# Remote')
        self.remote.git('add', 'README.md')
        self.remote.git_commit()

        self.local.write_file('README.md', '# Local')
        self.local.git('add', 'README.md')
        self.local.git_commit()

        self.assertEqual(main.main(), 0)

        self.assertTrue(self.git_force_push.called)
        self.assertFalse(self.git_delete_remote_branch.called)
        self.assertTrue(self.github_create_or_update_pull_request.called)

    def test_merge_related_histories_without_conflict(self):
        self.remote.write_file('README.md', '# Test')
        self.remote.write_file('LICENSE', '# Test')
        self.remote.git('add', 'README.md', 'LICENSE')
        self.remote.git_commit()

        self.local.write_file('README.md', '# Test')
        self.local.git('add', 'README.md')
        self.local.git_commit()

        self.assertEqual(main.main(), 0)

        self.assertTrue(self.git_force_push.called)
        self.assertFalse(self.git_delete_remote_branch.called)
        self.assertTrue(self.github_create_or_update_pull_request.called)

        self.local.git('remote', 'rm', 'upstream')
        self.remote.write_file('LICENSE', '# Updated')
        self.remote.git('add', 'LICENSE')
        self.remote.git_commit()

        self.assertEqual(main.main(), 0)

        self.assertTrue(self.git_force_push.called)
        self.assertFalse(self.git_delete_remote_branch.called)
        self.assertTrue(self.github_create_or_update_pull_request.called)

    def test_merge_exclude_with_unresolvable_conflicts(self):
        pr_branch = 'chore/merge-upstream-into-master'
        remote_version = '0.0.0'
        expected_version = '1.0.0'
        expected_summary = f'chore({os.path.basename(self.local.work_tree)}):' \
                           ' merge owner/upstream@master'

        self.remote.write_file('README.md', '# Remote')
        self.remote.write_file('version.txt', remote_version)
        self.remote.git('add', 'README.md', 'version.txt')
        self.remote.git_commit()

        self.local.write_file('README.md', '# Local')
        self.local.write_file('version.txt', expected_version)
        self.local.git('add', 'README.md', 'version.txt')
        self.local.git_commit()

        with environ({'MERGE_EXCLUDE': '/version.txt\n'}):
            self.assertEqual(main.main(), 0)

        actual_version = self.local.git('show', 'HEAD:version.txt', output=True)
        actual_summary = self.local.git('log', '-1', '--format=format:%s', output=True)

        self.assertEqual(expected_version, actual_version)
        self.assertEqual(expected_summary, actual_summary)
        self.git_force_push.assert_called_with(pr_branch, pr_branch)
        self.assertFalse(self.git_delete_remote_branch.called)
        self.assertTrue(self.github_create_or_update_pull_request.called)

    def run(self, result=None):
        with temporary_git_repository() as remote,\
                temporary_git_repository() as local:
            self.remote = remote
            self.local = local

            with cwd(self.local.work_tree):
                with fake_github_action_environ():
                    super(TestMain, self).run(result)

    def setUp(self):
        self.git_remote_add_patch = patch('main.git_remote_add')
        self.git_remote_add = self.git_remote_add_patch.start()
        self.git_remote_add.side_effect = self.fake_git_remote_add

        self.git_force_push_patch = patch('main.git_force_push')
        self.git_force_push = self.git_force_push_patch.start()
        self.git_force_push.side_effect = self.fake_git_force_push

        self.git_delete_remote_branch_patch = patch('main.git_delete_remote_branch')
        self.git_delete_remote_branch = self.git_delete_remote_branch_patch.start()

        self.github_create_or_update_pull_request_patch = patch('main.github_create_or_update_pull_request')
        self.github_create_or_update_pull_request = self.github_create_or_update_pull_request_patch.start()

    def tearDown(self):
        self.git_remote_add_patch.stop()
        self.git_force_push_patch.stop()
        self.git_delete_remote_branch_patch.stop()
        self.github_create_or_update_pull_request_patch.stop()

    def fake_git_remote_add(self, name, url):
        self.assertIn('x-github-token', url)
        subprocess.check_call(['git', 'remote', 'add', name, self.remote.work_tree])

    def fake_git_force_push(self, ref, branch):
        self.assertEqual(main.git('merge-base', 'master', ref, check=False), 0,
                         'a common ancestor is required to open a PR')


if __name__ == '__main__':
    unittest.main()
