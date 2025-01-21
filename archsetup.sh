#!/bin/sh

_pacman_install() {
	for pkg in "$@"; do
		if ! pacman -Q "$pkg" &>/dev/null; then
			sudo pacman -S "$pkg" --noconfirm
		fi
	done
}

install_requirements() {
	basics=("man" "base-devel" "git" "tmux" "neovim"  "npm" "unzip" "python" "htop")
	fonts=("ttf-font-awesome" "xorg-font-util" "xorg-fonts-misc" "noto-fonts" "xorg-fonts-misc")
	desktop=("firefox" "xorg-server" "rofi" "alacritty" "xorg-xinit" "pavucontrol" "flameshot" "discord" "steam" "bitwarden" "xclip" "nm-connection-editor" "networkmanager-openconnect" "networkmanager" "network-manager-applet" "scrot" "feh" "nextcloud-client" "zathura")
	utils=("bluez" "bluez-utils" "blueman" "bluez-utils" "arandr" "fzf" "ripgrep" "screenfetch")
	programming=("stack" "texlive-basic" "texlive-latex" "texlive-latexrecommended" "texlive-latexextra" "texlive-mathscience")

	_pacman_install ${basics[@]}
	_pacman_install ${fonts[@]}
	_pacman_install ${desktop[@]}
	_pacman_install ${utils[@]}
	_pacman_install ${programming[@]}
}

enable_services() {
	sudo systemctl enable NetworkManager --now
	sudo systemctl enable bluetooth --now
	sudo usermod -aG lp $USER
}

nvidia() {
	if ! pacman -Q "nvidia" &>/dev/null; then
		sudo pacman -S "nvidia" --noconfirm
	fi
}

aur_requrements() {
	packages=("wmcpuload" "windowmaker" "windowmaker-extra" "wmsystemtray" "spotify" "wmudmount" "wmcalclock" "ghcup-hs-bin")
	for pkg in "${packages[@]}"; do
		if ! yay -Q "$pkg" &>/dev/null; then
			yay -S "$pkg" --noconfirm
		fi
	done
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

windowmaker_setup() {
	echo "wmaker" > $HOME/.config/desktop.sh
  if command -v wmaker &>/dev/null; then
	  return
  fi
  yay -Syy windowmaker windowmaker-extra
}

install_requirements
aur_setup
aur_requrements
nvidia
windowmaker_setup
enable_services
