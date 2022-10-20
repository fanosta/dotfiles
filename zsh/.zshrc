POWERLEVEL10K_HOME=~/.powerlevel10k
if [[ ! -e "$POWERLEVEL10K_HOME"/powerlevel10k.zsh-theme ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$POWERLEVEL10K_HOME"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LANG=en_GB.UTF-8
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty2 ]]; then
  export XKB_DEFAULT_LAYOUT=us,de
  export XKB_DEFAULT_OPTIONS=grp:alt_space_toggle,caps:escape
  exec sway
fi

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  source <(dbus-launch)
  export DBUS_SESSION_BUS_PID
  export DBUS_SESSION_BUS_ADDRESS
  exec startx
fi

if [[ -z $DISPLAY && $(tty) == /dev/tty3 && $XDG_SESSION_TYPE == tty ]]; then
  export XKB_DEFAULT_LAYOUT=us,de
  export XKB_DEFAULT_OPTIONS=grp:alt_space_toggle,caps:escape
  export MOZ_ENABLE_WAYLAND=1
  export QT_QPA_PLATFORM=wayland
  export XDG_SESSION_TYPE=wayland
  exec dbus-run-session gnome-session
fi

if [[ ! -z "$SSH_CLIENT" ]] || [[ ! -z "$SSH_TTY" ]] && [[ -z $TMUX ]]; then
  exec tmux new-session -At ssh
fi

source "$POWERLEVEL10K_HOME"/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



DEFAULT_USER=marcel
COMPLETION_WAITING_DOTS="true"

source ~/.aliases.zsh
fpath=(~/.func $fpath)
autoload ~/.func/*

trap 'src' SIGURG
