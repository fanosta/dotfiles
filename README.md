Dotfiles
========

Contents
--------

| directory  | contents                               |
| ---------  | -------------------------------------- |
| `i3/`      | i3 desktop manger config               |
| `ipython/` | ipython config + profiles              |
| `nvim/`    | neovim config                          |
| `scripts/` | comprehensive suite of utility scripts |
| `tmux/`    | tmux config                            |
| `zsh/`     | zsh config                             |


Installation
------------

To install symlinks from your home directory to the relevant files you can use GNU stow.
For example,
```bash
stow --restow scripts
```
creates symlinks in `~/.bin/` pointing to each script in `scripts/.bin`.
The `--restow` option ensures obsolete symlinks are deleted.
