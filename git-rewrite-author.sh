
#!/bin/bash

# A script to change the author and committer information throughout the Git repository's history. You can replace 
# the name and/or email address.

function print_usage {
  echo "USAGE: git-rewrite-author [-fn|--from_name FROM_NAME] [-fe|--from_email FROM_EMAIL] [-tn|--to_name TO_NAME] [-te|--to_email TO_EMAIL]

OPTIONS:
  -fn, --from_name        Name to replace
  -fe, --from_email       Email to replace
  -tn, --to_name          New name to use
  -te, --to_email         New email to use
  -h, --help              Show help information.

INSTRUCTIONS:
  - Create a bare clone of the repository:
    git clone --bare https://github.com/user/repo.git
  - Change into it's directory:
    cd repo.git
  - Run git-rewrite-author.
  - Force-push the changes to update the repository remote:
    git push --force --tags origin 'refs/heads/*'
  - Delete the bare clone:
    cd ..
    rm -rf repo.git

ADDITIONAL:
  - You must provide either an old name or an old email to match against.
  - You must provide either a new name or new email to change to.
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
    -fn|--from_name)
	    FROM_NAME="$2"
	    shift
	    shift
    ;;
    -fe|--from_email)
	    FROM_EMAIL="$2"
	    shift
	    shift
    ;;
    -tn|--to_name)
	    TO_NAME="$2"
      shift
      shift
    ;;
    -te|--to_email)
      TO_EMAIL="$2"
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

## Ensure either a name or email to change from has been provided
if [ -z "$FROM_NAME" ] && [ -z "$FROM_EMAIL" ]; then
   echo "Please provide either a name or email to change from using -fn or -fe"
   exit 1
fi

## Ensure either a name or email to change to has been provided
if [ -z "$TO_NAME" ] && [ -z "$TO_EMAIL" ]; then
   echo "Please provide either a name or email to change to using -tn or -te"
   exit 2
fi

## Run the Git command to perform the replacement
git filter-branch --env-filter "

  if [ \"\$GIT_COMMITTER_NAME\" = \"${FROM_NAME}\" ] || [ \"\$GIT_COMMITTER_EMAIL\" = \"${FROM_EMAIL}\" ]
  then
    [ ! -z \"${FROM_NAME}\" ] && export GIT_COMMITTER_NAME=\"${TO_NAME}\"
    [ ! -z \"${FROM_EMAIL}\" ] && export GIT_COMMITTER_EMAIL=\"${TO_EMAIL}\"
  fi
  if [ \"\$GIT_AUTHOR_NAME\" = \"${FROM_NAME}\" ] || [ \"\$GIT_AUTHOR_EMAIL\" = \"${FROM_EMAIL}\" ]
  then
    [ ! -z \"${FROM_NAME}\" ] && export GIT_AUTHOR_NAME=\"${TO_NAME}\"
    [ ! -z \"${FROM_EMAIL}\" ] && export GIT_AUTHOR_EMAIL=\"${TO_EMAIL}\"
  fi
  " $@ --tag-name-filter cat -- --branches --tags

exit 0