#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)
#script requires latest version of .netcore to be installed ()

usage() { echo "Usage: git_fetch.sh -u <githubRepository> -s <relative save location>" 1>&2; exit 1; }

declare githubRepository=""
declare relativeSaveLocation=""

# Initialize parameters specified from command line
while getopts ":u:s:" arg; do
    case "${arg}" in
        u)
            githubRepository=${OPTARG}
        ;;
        s)
            relativeSaveLocation=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$githubRepository" ]]; then
    echo "Enter the github url (ssh/https) from which to clone the application source:"
    echo "NOTE: if https, the repository needs to be public."
    read githubRepository
fi

if [[ -z "$relativeSaveLocation" ]]; then
    echo "Path relative to script in which to download and build the app"
    echo "Enter an relative path to save location "
    read relativeSaveLocation
    [[ "${relativeSaveLocation:?}" ]]
fi

if [ -z "$githubRepository" ] || [ -z "$relativeSaveLocation" ]; then
    echo "Either githubRepository, or relativeSaveLocation is empty"
    usage
fi

#DEBUG
echo $githubRepository
echo $relativeSaveLocation
echo ''

rm -rf $relativeSaveLocation

mkdir $relativeSaveLocation

pushd $relativeSaveLocation;

#clone the repository
git clone --branch refactor/bg-2-ingress $githubRepository 1> /dev/null

echo "Git clone completed."