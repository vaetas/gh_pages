class GithubPagesException implements Exception {
  const GithubPagesException([this.message]);

  final Object? message;

  @override
  String toString() => 'GithubPagesException: $message';
}

class NotGitDirectoryException extends GithubPagesException {
  const NotGitDirectoryException([String? message]) : super(message);

  @override
  String toString() => 'NotGitDirectory: $message';
}

class MissingRemoteException extends GithubPagesException {
  const MissingRemoteException([String? message]) : super(message);

  @override
  String toString() => 'MissingRemoteException: $message';
}
