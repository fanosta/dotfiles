# start sway if on term 1
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

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

if [[ "$TERM" != "linux" && "$TERM" != "vt220" ]]; then
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi

  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
  #POWERLEVEL10K_MODE='compatible'
  #ZSH_THEME="powerlevel10k/powerlevel10k"
  #ZSH_THEME="agnoster"
  POWERLEVEL10K_LEFT_PROMPT_ELEMENTS=(virtualenv context dir vcs dir_writable)
  POWERLEVEL10K_RIGHT_PROMPT_ELEMENTS=(status background_jobs)
  #POWERLEVEL10K_BATTERY_STAGES="▁▂▃▄▅▆▇█"
  POWERLINE_CONFIG_COMMAND="/home/marcel/.local/bin/powerline-daemon"
  POWERLEVEL10K_SHORTEN_DIR_LENGTH=2

  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
else
  source .grml.zsh
fi

COMPLETION_WAITING_DOTS="true"
# export TERM="xterm-256color"

plugins=(git common-aliases docker systemd zsh_reload colored-man-pages zsh-syntax-highlighting)

DEFAULT_USER=marcel
source $ZSH/oh-my-zsh.sh

# virtual envs
# export WORKON_HOME=~/.virtualenvs
# source /usr/bin/virtualenvwrapper.sh

# exa
alias exa='exa --group-directories-first'
alias l='exa --git-ignore --git -l'
alias ldot='exa --git -ld .*'
alias la='exa --git -la'
alias ls='exa'
alias lg='exa --git-ignore'

# personal aliases
alias xc='xclip -selection clipboard'
alias psgrep='ps aux | head -n 1; ps aux | grep -v grep | grep $1'
# alias cdtmp='cd $(mktemp -d)'
alias mktmp='mktemp'
alias cp='cp --reflink=auto'
alias se='sudoedit'
alias hd='hexdump -C'
which ipython3 > /dev/null && alias p3='ipython3' || alias p3='python3'
which ipython2 > /dev/null && alias p2='ipython2' || alias p2='python2'
alias w='which'
alias no_aslr='setarch `uname -m` -R'
alias ip='ip --color=auto'
alias ip6='ip -6'
alias ip4='ip -4'
alias gh='git help'
alias gla='git pull --rebase --autostash'
alias e="$EDITOR"
alias CAPS='xdotool key Caps_Lock'
alias 'c.'='code .'
alias backup='sudo backup'
alias srcall='killall -URG zsh'
alias x='exec xonsh'
alias whatthecommit='gc -t <(curl -Ss whatthecommit.com | tr -d "\n" | grep -oP "(?<=<p>).*?(?=</p>)")'

# git aliases
alias gla='git pull --autostash'
alias gid='git icdiff'
alias gidca='git icdiff --cached'
alias gidcw='git icdiff --cached --word-icdiff'
alias gidct='git describe --tags `git rev-list --tags --max-count=1`'
alias gids='git icdiff --staged'
alias gidt='git icdiff-tree --no-commit-id --name-only -r'
alias gidw='git icdiff --word-icdiff'
alias mx='chmod +x'
alias m='make -j16'
alias make='make -j16'

alias pc='playerctl'

fpath=(~/.func $fpath)
autoload ~/.func/*

trap 'src' SIGURG
