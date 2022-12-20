#!/bin/bash
set -eu

stow --restow "$@"

for part in "$@"; do
  if [[ -f "$part/post_install" ]]; then
    echo "running script $part/post_install"
    "$part/post_install"
  fi
done
