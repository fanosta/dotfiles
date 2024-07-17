if [[ ! -z "$SSH_CLIENT" ]] || [[ ! -z "$SSH_TTY" ]] && [[ -z $TMUX ]]; then
  exec tmux new-session -At ssh
fi

which vi > /dev/null && export EDITOR=vi
which vim > /dev/null && export EDITOR=vim
which nvim > /dev/null && export EDITOR=nvim

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

autoload -Uz compinit
compinit

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
source "$POWERLEVEL10K_HOME"/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "${ZDOTDIR:-$HOME}/.p10k.zsh" ]] || source "${ZDOTDIR:-$HOME}/.p10k.zsh"

# ssh agent setup
if [[ -z "$SSH_AUTH_SOCK" ]] then
    if [[ -f ~/.ssh/agent.env ]] ; then
        source ~/.ssh/agent.env > /dev/null
        if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
            eval `ssh-agent | tee ~/.ssh/agent.env` > /dev/null
        fi
    else
        eval `ssh-agent | tee ~/.ssh/agent.env` > /dev/null
        ssh-add
    fi
fi

# only autocomplete temporary latex files for nvim if no other option left
zstyle ':completion:*:*:(vim|nvim):*' file-patterns '^*.(pdfpc|gnuplot|pgf-plot.table|log|brf|xdv|aux|bbl|blg|lof|log|toc|out|nav|snm|vrb|bcf|run.xml|acn|acr|alg|glg|glo|gls|idx|ilg|ind|nlo|nls|xdy|glsdefs|tps|tcp|lot|xwm|synctex.gz|fls|fdb_latexmk|auxlock|dpth|md5|pdf):source-files' '*:all-files'
zstyle ':completion:*:*:(rifle):*' file-patterns '^*.(bib|tex|pdfpc|gnuplot|pgf-plot.table|log|brf|xdv|aux|bbl|blg|lof|log|toc|out|nav|snm|vrb|bcf|run.xml|acn|acr|alg|glg|glo|gls|idx|ilg|ind|nlo|nls|xdy|glsdefs|tps|tcp|lot|xwm|synctex.gz|fls|fdb_latexmk|auxlock|dpth|md5):source-files' '*:all-files'


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

# make ctrl-w break on special chars
autoload -U select-word-style
select-word-style bash
WORDCHARS='.-'

# autocd
setopt autocd
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'
alias .......='../../../../../..'

setopt histignorespace # don't save commands tarting with space to history

# better history scroll
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "\e[A" up-line-or-beginning-search # Up
bindkey "\e[B" down-line-or-beginning-search # Down

# jump words with ctrl-left/right
bindkey "$terminfo[kLFT5]" backward-word # CTRL-Left
bindkey "$terminfo[kRIT5]" forward-word # CTRL-Right


source "${ZDOTDIR:-$HOME}/.aliases.zsh"
source "${ZDOTDIR:-$HOME}/.aliases.git.zsh"
source "${ZDOTDIR:-$HOME}/.systemd.plugin.zsh"
fpath=("${ZDOTDIR:-$HOME}/.func" $fpath)
autoload "${ZDOTDIR:-$HOME}/.func/"*

# use ctrl-z as fg
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# reload ~/.zshrc on SIGURG
trap 'echo reloading \~/.zshrc; source "${ZDOTDIR:-$HOME}/.zshrc"' SIGURG
alias srcall='killall -URG zsh'

# iterm 2 integration
if [[ -e "${HOME}/.iterm2_shell_integration.zsh" ]] then
  source "${HOME}/.iterm2_shell_integration.zsh"
fi

# virtualenvs
if which virtualenvwrapper.sh > /dev/null; then
  source $(which virtualenvwrapper.sh)

  function chpwd() {
    if [[ -f .venv ]]; then
      local _VENV="$(cat .venv)"
      if [[ -z "$VIRTUAL_ENV_PROMPT" ]] || [[ "$VIRTUAL_ENV_PROMPT" != "$_VENV" ]]; then
        workon "$_VENV"
      fi
    fi
  }

  chpwd
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
