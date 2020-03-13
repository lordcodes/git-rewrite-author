# Git rewrite author 👤

[![@lordcodes](https://img.shields.io/badge/contact-@lordcodes-blue.svg?style=flat)](https://twitter.com/lordcodes)
[![Lord Codes Blog](https://img.shields.io/badge/blog-Lord%20Codes-yellow.svg?style=flat)](https://www.lordcodes.com)

A script to change your email address across a Git repository's full history.

&nbsp;

<p align="center">
    <a href="#install">Install</a> • <a href="#usage">Usage</a> • <a href="#contributing-or-help">Contributing</a>
</p>

## Install

Download the script from GitHub or clone the repository and move it to your preferred location.

It should already be executable, but it not: `chmod a+x git-rewrite-author.sh`.

## Usage

1. Create a bare clone of the repository you run to run the script on.
    
    `git clone --bare https://github.com/user/repo.git`

2. Change into it's directory.

    `cd repo.git`

3. Run git-rewrite-author.

    `git-rewrite-author -oe old@email.com -cn "Correct Name" -ce correct@email.com`

4. Check you are happy with the changes using git log.
5. Make sure you are absolutely happy to continue.
6. Force-push to update the remote repository.

    `git push --force --tags origin 'refs/heads/*'`

7. Delete the bare clone.

    `cd .. && rm -rf repo.git`

### Additional information

- You must provide an old email for Git to match against.
- You must provide a new name and email to update to.
- Both the author and committer information will be replaced.

### Script options

```
USAGE: git-rewrite-author [-oe|--old_email EMAIL] [-cn|--correct_name NAME] [-ce|--correct_email EMAIL]

OPTIONS:
  -oe, --old_email        Email to replace
  -cn, --correct_name     New name to use
  -ce, --correct_email    New email to use
  -h, --help              Show help information.
```

## Contributing or Help

If you notice any bugs or have a new feature to suggest, please check out the [contributing guide](https://github.com/lordcodes/git-rewrite-author/blob/master/CONTRIBUTING.md). If you want to make changes, please make sure to discuss anything big before putting in the effort of creating the PR.

To reach out please contact [@lordcodes on Twitter](https://twitter.com/lordcodes).
