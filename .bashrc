export PATH="$PATH:$HOME/.local/bin/nvim/bin:$HOME/.local/bin"
if [ -n "$TERM" ] && [ "$TERM" != "dumb" ]; then
  export PS1='\[\033[32m\]\u@\h\[\033[0m\](\w)> '
else
      export PS1='\u@\h:\w\$ '
fi

source "$HOME/.config/alias.sh"
