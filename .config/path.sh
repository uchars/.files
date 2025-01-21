if [ -d "$HOME/.local/bin/nvim/bin" ]; then
	PATH="$HOME/.local/bin/nvim/bin:$PATH"
fi

if [ -d "$HOME/.local/bin/fd/" ]; then
	PATH="$HOME/.local/bin/fd/:$PATH"
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
