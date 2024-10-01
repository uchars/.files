# editor
alias v="nvim"
alias nv="nvim"

# git
alias gs="git status"
alias gf="git fetch --all"
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "[WIP]: $(date)"'
alias gundo="git reset HEAD~"
alias gcm="git-credential-manager"
alias gl="git log"

# apt
alias agi="sudo apt-get install "

# finding
alias p="ps aux | grep -i "
alias h="history | grep -i "
alias diskspace="du -S | sort -nr | more"

# list
alias ll="ls -al"
alias la="ls -A"

# keyboard
alias kger="setxkbmap de"
alias kus="setxkbmap us"

alias ..="cd .."
