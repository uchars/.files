if [ -d "$HOME/.local/bin/nvim/bin" ]; then
	PATH="$HOME/.local/bin/nvim/bin:$PATH"
fi

if [ -d "$HOME/.local/bin/fd/" ]; then
	PATH="$HOME/.local/bin/fd/:$PATH"
fi

if [ -d "$HOME/.local/bin/jdt/bin" ]; then
	PATH="$HOME/.local/bin/jdt/bin/:$PATH"
fi

if [ -d "$HOME/.local/bin/" ]; then
	PATH="$HOME/.local/bin/:$PATH"
fi

if [ -d "$HOME/.config/emacs/bin" ]; then
	PATH="$HOME/.config/emacs/bin:$PATH"
fi

if [ -d "/usr/lib64/GNUstep/Applications/WPrefs.app" ]; then
	PATH="/usr/lib64/GNUstep/Applications/WPrefs.app/:$PATH"
fi

if [ -d "$HOME/.ghcup/bin" ]; then
	PATH="$HOME/.ghcup/bin:$PATH"
fi

if [ -d "$HOME/Downloads/zig-linux-x86_64-0.14.0" ]; then
	PATH="$HOME/Downloads/zig-linux-x86_64-0.14.0:$PATH"
fi
