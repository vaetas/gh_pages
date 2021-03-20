# Publish to Github Pages.

Dart implementation of [gp-pages](https://github.com/tschaub/gh-pages) package. This package takes 
all files from within a selected subfolder, copies them into `gh-pages` branch and uploads it to 
the remote origin.

## Installation

To use `gh_pages` outside of Dart projects activate it globally.

```text
pub global activate gh_pages
```

You can also import it into your Dart project and call it from within.

```yaml
dependencies:
  gh_pages: ^0.1.0
```

## Usage

Publish `<dir>` to `gh-pages` branch and push to remote.

```text
gh_pages <dir>
```

Run `gh_pages --help` or `gh_pages -h` to show usage help with all options.