
#!/bin/bash

# A script to change the author and committer information throughout a Git repository's history. You provide an old 
# email address to match against and the correct name and email to replace with.

function print_usage {
  echo "USAGE: git-rewrite-author [-oe|--old_email EMAIL] [-cn|--correct_name NAME] [-ce|--correct_email EMAIL]

OPTIONS:
  -oe, --old_email        Email to replace
  -cn, --correct_name     New name to use
  -ce, --correct_email    New email to use
  -h, --help              Show help information.

INSTRUCTIONS:
  - Create a bare clone of the repository:
    git clone --bare https://github.com/user/repo.git
  - Change into it's directory:
    cd repo.git
  - Run git-rewrite-author.
  - Check you are happy with the changes, by looking at the git log.
  - Force-push the changes to update the repository remote:
    git push --force --tags origin 'refs/heads/*'
  - Delete the bare clone:
    cd ..
    rm -rf repo.git

ADDITIONAL:
  - You must provide an old email to match against.
  - You must provide a new name and email to change to.
  - Both the author and committer details will be replaced."
}

# Parse the command line arguments
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  arg="$1"

  case $arg in
    -h|--help)
	    print_usage
	    exit 0
	    shift
    ;;
    -oe|--old_email)
	    OLD_EMAIL="$2"
	    shift
	    shift
    ;;
    -cn|--correct_name)
	    CORRECT_NAME="$2"
      shift
      shift
    ;;
    -ce|--correct_email)
      CORRECT_EMAIL="$2"
      shift
      shift
    ;;
    *)
      POSITIONAL+=("$1")
      shift
    ;;
   esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

## Ensure an email to replace has been provided
if [ -z "$OLD_EMAIL" ]; then
   echo "Please provide an email to replace using -oe"
   exit 1
fi

## Ensure a new name and email have been provided
if [ -z "$CORRECT_NAME" ] || [ -z "$CORRECT_EMAIL" ]; then
   echo "Please provide a name and email to change to using -cn and -ce"
   exit 2
fi

## Run the Git command to perform the replacement
git filter-branch --env-filter "

  if [ \"\$GIT_COMMITTER_EMAIL\" = \"$OLD_EMAIL\" ]
  then
      export GIT_COMMITTER_NAME=\"$CORRECT_NAME\"
      export GIT_COMMITTER_EMAIL=\"$CORRECT_EMAIL\"
  fi
  if [ \"\$GIT_AUTHOR_EMAIL\" = \"$OLD_EMAIL\" ]
  then
      export GIT_AUTHOR_NAME=\"$CORRECT_NAME\"
      export GIT_AUTHOR_EMAIL=\"$CORRECT_EMAIL\"
  fi
  " $@ --tag-name-filter cat -- --branches --tags

echo "Check you are happy with the changes, by looking at the git log."
echo "Please be careful and make sure you are sure you want to continue."
echo "If you are then force-push the changes using:"
echo "git push --force --tags origin 'refs/heads/*'"

exit 0