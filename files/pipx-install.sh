#!/bin/sh

set -eu

package="$1"
version="$2"

pipx_list="$(pipx list)"

if echo "$pipx_list" | grep --fixed-strings --quiet "package $package "; then
    echo "Package is already installed."
    if echo "$pipx_list" | grep --fixed-strings --quiet "package $package $version,"; then
        echo "Package has the correct version."
        exit 0
    else
        echo "Package has not the correct version."
        echo "Uninstall package..."
        pipx uninstall $package
    fi
else
    echo "Package is not installed."
fi

echo "Install package..."

pipx install $package==$version

if ! pipx list | grep --fixed-strings --quiet "package $package $version,"; then
    echo "Something went wrong. Package not installed in the correct version."
    exit 1
else
    echo "Package installed."
    echo status=changed
fi
