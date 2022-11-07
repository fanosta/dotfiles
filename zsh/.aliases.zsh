# aliases
# exa
if which exa &> /dev/null; then
    alias exa='exa --group-directories-first'
    alias l='exa --git-ignore --git -l'
    alias ldot='exa --git -ld .*'
    alias la='exa --git -la'
    alias ls='exa'
    alias lg='exa --git-ignore'
fi

# global aliases
alias -g L='| less -R'
alias -g H='| head'
alias -g T='| tail'
alias -g NE='2>/dev/null'

# reduce danger
alias rm-='rm -i'
alias cp-='cp -i'
alias mv-='mv -i'

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
#source ~/.aliases.git.zsh

alias mx='chmod +x'
alias m='make -j16'
alias make='make -j16'

alias pc='playerctl'

