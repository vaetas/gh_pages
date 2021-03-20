import 'package:gh_pages/src/exceptions.dart';
import 'package:git/git.dart';
import 'package:path/path.dart';

export 'src/exceptions.dart';

/// Publish specific directory from git repository to Github Pages.
///
/// * [workingDirectory] must be a git repository.
/// * [branch] is optional and defaults to 'gh-pages'.
class GithubPages {
  GithubPages({
    required this.workingDirectory,
    this.branch = 'gh-pages',
  });

  final String workingDirectory;
  final String branch;

  late final GitDir gitDir;

  // FIXME: This method fails when commit message is same as the last one.
  /// Update [branch] with content of [publishDirectory].
  ///
  /// The [publishDirectory] must be under the [workingDirectory] provided
  /// in the constructor.
  ///
  /// [commitMessage] is optional and defaults to 'Deploy on [DateTime.now]'.
  Future<void> updateBranch({
    required String publishDirectory,
    String? commitMessage,
  }) async {
    if (!await GitDir.isGitDir(workingDirectory)) {
      throw NotGitDirectoryException(
        "'$workingDirectory' is not a git directory.",
      );
    }
    gitDir = await GitDir.fromExisting(workingDirectory);

    try {
      await gitDir.updateBranchWithDirectoryContents(
        branch,
        join(workingDirectory, publishDirectory),
        commitMessage ?? '🚀 Deploy on ${DateTime.now().toIso8601String()}',
      );
    } catch (e) {
      throw GithubPagesException(e);
    }
  }

  /// Pushes updated [branch] to remote repository.
  ///
  /// Throws when the current git directory has no remotes.
  Future<void> publish({
    String remote = 'origin',
  }) async {
    if (!await _hasRemotes()) {
      throw const MissingRemoteException(
        'Current git directory has no remotes.',
      );
    }

    await gitDir.runCommand(['push', remote, branch]);
  }

  Future<bool> _hasRemotes() async {
    final result = await gitDir.runCommand(['remote']);
    if (result.exitCode != 0) {
      throw const GithubPagesException('Could not list remotes.');
    }
    if (result.stdout is! String) {
      throw const GithubPagesException(
        "Invalid result for 'git remote' command.",
      );
    }
    final remotes = result.stdout as String;
    return remotes.isNotEmpty;
  }
}
