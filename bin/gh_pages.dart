// ignore_for_file: avoid_print

import 'package:args/args.dart';
import 'package:gh_pages/gh_pages.dart';
import 'package:path/path.dart' as p;

Future<int> main(List<String> arguments) async {
  final workingDir = p.current;
  final argParser = ArgParser()
    ..addOption(
      'message',
      abbr: 'm',
      defaultsTo: '🚀 Deploy on ${DateTime.now().toIso8601String()}',
      help: 'Commit message',
    )
    ..addOption(
      'branch',
      defaultsTo: 'gh-pages',
      abbr: 'b',
    )
    ..addFlag(
      'no-publish',
      negatable: false,
      defaultsTo: false,
      help: 'Only update local branch and do not push changes upstream.',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      defaultsTo: false,
      negatable: false,
      help: 'Show help.',
    );
  final args = argParser.parse(arguments);

  final displayHelp = args['help'] as bool;
  if (displayHelp) {
    print(argParser.usage);
    return 0;
  }

  if (args.rest.length != 1) {
    print('Invalid command invocation!');
    print('Usage: gh_pages <dir> [options]');
    return 1;
  }
  final dir = args.rest.first;
  final message = args['message'] as String;
  final noPublish = args['no-publish'] as bool;
  final branch = args['branch'] as String;
  try {
    final githubPages = GithubPages(
      workingDirectory: workingDir,
      branch: branch,
    );
    await githubPages.updateBranch(
      publishDirectory: dir,
      commitMessage: message,
    );
    print('Committing files to branch $branch successful.');
    if (noPublish) {
      print('Skipping push to remote.');
    } else {
      await githubPages.publish();
      print('Deploy successful.');
    }
  } on GithubPagesException catch (e) {
    print(e);
  }
  print('Done!');
  return 1;
}
