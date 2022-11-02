if [[ ! -z "$SSH_CLIENT" ]] || [[ ! -z "$SSH_TTY" ]] && [[ -z $TMUX ]]; then
  exec tmux new-session -At ssh
fi


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# clone on demand
POWERLEVEL10K_HOME=~/.powerlevel10k
if [[ ! -e "$POWERLEVEL10K_HOME"/powerlevel10k.zsh-theme ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$POWERLEVEL10K_HOME"
fi

if [[ ! -e "${ZDOTDIR:-$HOME}/.zprezto" ]]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
source "$POWERLEVEL10K_HOME"/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ssh agent setup
if [ -f ~/.ssh/agent.env ] ; then
    . ~/.ssh/agent.env > /dev/null
    if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
        eval `ssh-agent | tee ~/.ssh/agent.env` > /dev/null
    fi
else
    eval `ssh-agent | tee ~/.ssh/agent.env` > /dev/null
    ssh-add
fi

# history
HISTFILE="$HOME/.cache/zsh_history"
HISTSIZE=1000000
setopt SHARE_HISTORY
SAVEHIST="$HISTSIZE"


bindkey -e # emacs mode

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
bindkey '^U' backward-kill-line
bindkey '^K' kill-line


# better history scroll
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "$terminfo[kcuu1]" up-line-or-beginning-search # Up
bindkey "$terminfo[kcud1]" down-line-or-beginning-search # Down


source ~/.aliases.zsh
source ~/.aliases.git.zsh
fpath=(~/.func $fpath)
autoload ~/.func/*

#trap 'src' SIGURG
