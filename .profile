# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

if [ -x "$(command -v xinput)" ]; then
	device_id=$(xinput list | grep "Touchpad" | awk '{print $6}' | cut -d '=' -f 2)
	#xinput set-prop $device_id "libinput Natural Scrolling Enabled" 1
fi

#if ! [[ $(/bin/pgrep -f "dwmstatus.sh") ]]; then
#	if [ -x "$(command -v dwmstatus.sh)" ]; then
#		dwmstatus.sh &
#	fi
#fi

command -v setxkbmap >/dev/null 2>&1 && setxkbmap us

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

if ! [ -d "/tmp/scratch" ]; then
	mkdir /tmp/scratch
fi
. "$HOME/.cargo/env"
