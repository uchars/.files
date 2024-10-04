if [ -d "$HOME/.local/bin/nvim/bin" ]; then
    PATH="$HOME/.local/bin/nvim/bin:$PATH"
fi

if [ -d "$HOME/.local/bin/fd/" ]; then
    PATH="$HOME/.local/bin/fd/:$PATH"
fi
