# aliases
# exa
if which exa &> /dev/null; then
  # debian built versions don't support --git :(
  if exa --git >/dev/null 2>&1; then
    alias ls='exa -F --color=always --icons --group-directories-first --git'
  else
    alias ls='exa -F --color=always --icons --group-directories-first'
  fi
else
  alias ls='ls --color=auto -F'
fi

# alias ls='ls --color=auto '
alias l='ls -lFh'     #size,show type,human readable
alias ll='ls -lFh'      #long list
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
alias lsr='ls -lARFh' #Recursive list of files and directories
alias lsn='ls -1'     #A column contains name of files and directories

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

