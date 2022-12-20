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

Use the `install.sh` script with the directory name of the components you want to install.
For example if you want to install the neovim config and the scripts use

```bash
./install.sh nvim scripts
```

Manual Installation
-------------------

To install symlinks from your home directory to the relevant files you can use GNU stow.
For example,
```bash
stow --restow scripts
```
creates symlinks in `~/.bin/` pointing to each script in `scripts/.bin`.
The `--restow` option ensures obsolete symlinks are deleted.

For some components there are `post_install` scripts.
Make sure to execute those as well.
