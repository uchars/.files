#!/bin/sh

_pacman_install() {
	for pkg in "$@"; do
		if ! pacman -Q "$pkg" &>/dev/null; then
			sudo pacman -S "$pkg" --noconfirm --needed
		fi
	done
}

_aur_install() {
	for pkg in "$@"; do if ! yay -Q "$pkg" &>/dev/null; then
			yay -S "$pkg" --noconfirm
		fi
	done
}


install_requirements() {
	basics=("man" "base-devel" "git" "tmux" "neovim"  "npm" "unzip" "python" "htop")
	fonts=("ttf-font-awesome" "xorg-font-util" "xorg-fonts-misc" "noto-fonts" "xorg-fonts-misc")
	desktop=("firefox" "xorg-server"  "alacritty" "xorg-xinit" "pavucontrol" "flameshot" "discord" "steam" "bitwarden" "xclip" "networkmanager-openconnect" "networkmanager" "network-manager-applet" "scrot" "feh" "nextcloud-client" "zathura" "yubikey-manager" "zathura-pdf-mupdf" "gvfs" "transmission-qt" "vlc" "mpv" "picom" "ly")
	utils=("bluez" "bluez-utils" "blueman" "bluez-utils" "arandr" "fzf" "ripgrep" "screenfetch" "tealdeer" "zip" "libfido2" "python-virtualenv" "mtpfs" "android-udev" "plymouth" "cantarell-fonts")
	uni_stuff=("stack" "texlive-basic" "texlive-latex" "texlive-latexrecommended" "texlive-latexextra" "texlive-mathscience" "pandoc")

	_pacman_install ${basics[@]}
	_pacman_install ${fonts[@]}
	_pacman_install ${desktop[@]}
	_pacman_install ${utils[@]}
	_pacman_install ${uni_stuff[@]}
}

gaming() {
	packages=("gamemode" "gamescope" "lib32-gamemode" "wine" "mangohud")
	_pacman_install ${packages[@]}
	sudo usermod -aG gamemode $USER
	yay_packages=("fightcade2")
	_aur_install ${yay_packages[@]}
}

_blueman() {
	sudo systemctl enable bluetooth --now
}

enable_services() {
	sudo systemctl enable NetworkManager --now
	sudo systemctl enable pcscd --now
	sudo usermod -aG lp $USER
	sudo usermod -aG adbusers $USER
}

nvidia() {
	drivers=("nvidia")
	_pacman_install ${drivers[@]}
}

aur_requrements() {
	packages=("spotify" "ghcup-hs-bin" "yubico-authenticator-bin")
	_aur_install ${packages[@]}
}

aur_setup() {
	if command -v yay &>/dev/null; then
		return
	fi
	if [ ! -d "/tmp/yay" ]; then
		git clone https://aur.archlinux.org/yay.git /tmp/yay
	fi
	makepkg -si -D /tmp/yay
}

kde_setup() {
	packages=("plasma")
	_pacman_install ${packages[@]}
	sudo systemctl enable ly --now --force
}

windowmaker_setup() {
	packages=("wmcpuload" "windowmaker" "windowmaker-extra" "wmsystemtray" "wmudmount" "wmcalclock" "wmtop" "wmnd" "wmamixer")
	pacman=("thunar" "nm-connection-editor" "thunar-archive-plugin" "thunar-volman" "rofi")
	_aur_install ${packages[@]}
	_pacman_install ${pacman[@]}
	echo "wmaker" > $HOME/.config/desktop.sh
	_blueman
	sudo systemctl enable ly --now
}

install_requirements
aur_setup
aur_requrements
nvidia
# windowmaker_setup
kde_setup
enable_services
gaming
