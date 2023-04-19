#!/bin/bash
set -eu

if grep -qi debian  /etc/os-release; then
  commands=(stow curl nvim)
  packages=(stow curl neovim)
  pkgs=()

  for i in "${!commands[@]}"; do
      if ! command -v "${commands[i]}" &> /dev/null; then
          pkgs+=("${packages[i]}")
      fi
  done

  if [ ${#pkgs[@]} -ne 0 ]; then
      echo "The following packages are not installed: ${pkgs[*]}"
      sudo apt update
      sudo apt install "${pkgs[@]}"
  fi
fi

stow --restow "$@"

for part in "$@"; do
  if [[ -f "$part/post_install" ]]; then
    echo "running script $part/post_install"
    "$part/post_install"
  fi
done
