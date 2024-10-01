export PATH="$PATH:$HOME/.local/bin/nvim/bin:$HOME/.local/bin"
if [ -n "$TERM" ] && [ "$TERM" != "dumb" ]; then
  export PS1='\[\033[32m\]\u@\h\[\033[0m\](\w)> '
else
      export PS1='\u@\h:\w\$ '
fi

source "$HOME/.config/alias.sh"
source "$HOME/.config/proxy.sh"

export EDITOR="nvim"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -s "$HOME/.config/secret.sh" ] && \. "$HOME/.config/secret.sh"

if [ -e "$HOME/.cargo/env" ] ; then
    . "$HOME/.cargo/env"
fi
