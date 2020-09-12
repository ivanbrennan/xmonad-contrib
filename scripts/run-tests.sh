#!/bin/sh

# Usage:
#   scripts/run-tests.sh tests/EXAMPLE.hs
#   XMONAD=/PATH/TO/XMONAD scripts/run-tests.sh tests/EXAMPLE.hs

set -e
set -u

toplevel=$(git rev-parse --show-toplevel)
XMONAD="${XMONAD:-$toplevel/../xmonad}"
main=$(realpath -e "$1")

instances_target="$XMONAD/tests/Instances.hs"
instances_symlink="$toplevel/tests/Instances.hs"

properties_target="$XMONAD/tests/Properties"
properties_symlink="$toplevel/tests/Properties"

utils_target="$XMONAD/tests/Utils.hs"
utils_symlink="$toplevel/tests/Utils.hs"

trap "
    rm '$instances_symlink' '$utils_symlink' '$properties_symlink' || true
" EXIT INT QUIT TERM

ln -s "$instances_target" "$instances_symlink"
ln -s "$properties_target" "$properties_symlink"
ln -s "$utils_target" "$utils_symlink"

runghc -DTESTING \
    -i"$toplevel" \
    -i"$toplevel/tests" \
    "$main"
