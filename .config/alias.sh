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
alias l="ls"

# keyboard
alias kger="setxkbmap de"
alias kus="setxkbmap us"

alias ..="cd .."

# sound
alias vol="amixer set Master --quiet"
alias mute="amixer set Master 1+ toggle --quiet"

# spotify
alias stitle="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '\"' -f 2"
alias snext="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next > /dev/null && stitle"
alias sstate="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | grep -oE '(Playing|Paused)'"
alias sn=snext
alias spause="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause > /dev/null"
alias stoggle="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause > /dev/null"
alias splay="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play > /dev/null"
alias srep="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Repeat > /dev/null && echo 'repeating stitle'"
alias sprev="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous > /dev/null && stitle"
alias sp=sprev
