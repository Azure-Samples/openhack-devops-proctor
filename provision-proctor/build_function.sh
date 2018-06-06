#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: build_function.sh -v <version>" 1>&2; exit 1; }

declare version=""

# Initialize parameters specified from command line
while getopts ":v:" arg; do
    case "${arg}" in
        v)
            version=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$version" ]]; then
    echo "This script will build Leaderboard application created by Azure Functions"
    echo "Enter the version of the application with semantic versioning like 1.0.0"
    read version
    [[ "${version:?}" ]]
fi

pushd .
cd ../leaderboard/api/Leaderboard
dotnet restore
dotnet publish -c Release

cd bin/Release/netstandard2.0/publish
zip -r Leaderboard$version.zip *
popd

mv ../leaderboard/api/Leaderboard/bin/Release/netstandard2.0/publish/*.zip .
