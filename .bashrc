# Source global definitions if they exist
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

export PATH="$PATH:$HOME/.local/bin/nvim/bin:$HOME/.local/bin"
if [ -n "$TERM" ] && [ "$TERM" != "dumb" ]; then
  export PS1='\[\033[32m\]\u@\h\[\033[0m\](\w)> '
else
  export PS1='\u@\h:\w\$ '
fi

[ -s "$HOME/.config/alias.sh" ] && \. "$HOME/.config/alias.sh"
[ -s "$HOME/.config/proxy.sh" ] && \. "$HOME/.config/proxy.sh"
[ -s "$HOME/.config/secret.sh" ] && \. "$HOME/.config/secret.sh"
[ -s "$HOME/.config/path.sh" ] && \. "$HOME/.config/path.sh"

export EDITOR="nvim"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

if [ -e "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"
