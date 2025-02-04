#!/bin/sh

_pacman_install() {
	for pkg in "$@"; do
		if ! pacman -Q "$pkg" &>/dev/null; then
			sudo pacman -S "$pkg" --noconfirm --needed
		fi
	done
}

_pip_install() {
	for pkg in "$@"; do
		pipx install "$pkg"
	done
}

_aur_install() {
	for pkg in "$@"; do if ! yay -Q "$pkg" &>/dev/null; then
			yay -S "$pkg" --noconfirm --needed
		fi
	done
}


install_requirements() {
	basics=("man" "base-devel" "git" "tmux" "neovim"  "npm" "unzip" "python" "htop")
	fonts=("ttf-font-awesome" "xorg-font-util" "xorg-fonts-misc" "noto-fonts" "xorg-fonts-misc")
	desktop=("firefox" "xorg-server" "alacritty" "xorg-xinit" "pavucontrol" "flameshot" "discord" "bitwarden" "xclip" "networkmanager" "scrot" "feh" "nextcloud-client" "zathura" "yubikey-manager" "zathura-pdf-mupdf" "gvfs" "transmission-qt" "vlc" "mpv" "picom" "ly" "cups" "cups-pdf")
	utils=("bluez" "bluez-utils" "fzf" "ripgrep" "screenfetch" "tealdeer" "zip" "libfido2" "python-virtualenv" "mtpfs" "android-udev" "plymouth" "cantarell-fonts")

	_pacman_install ${basics[@]}
	_pacman_install ${fonts[@]}
	_pacman_install ${desktop[@]}
	_pacman_install ${utils[@]}
}

gaming_setup() {
	packages=("gamemode" "gamescope" "lib32-gamemode" "wine" "mangohud" "steam")
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
	sudo systemctl enable cups --now
}

nvidia() {
	drivers=("nvidia-open" "nvidia-utils")
	_pacman_install ${drivers[@]}
}

aur_programs() {
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
	packages=("plasma system-config-printer" "tumbler")
	_pacman_install ${packages[@]}
	sudo systemctl enable ly --now --force
	_blueman
	aur_packages=("konsave")
	_aur_install ${aur_packages[@]}
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

uni_setup() {
	packages=("texlive-basic" "texlive-latex" "texlive-latexrecommended" "texlive-latexextra" "texlive-mathscience" "pandoc" "networkmanager-openconnect")
	_pacman_install ${packages[@]}
}

haskell_setup() {
	packages=("stack")
	_pacman_install ${packages[@]}
}

enable_wol() {
	local device="$1"
    packages=("ethtool")
    _pacman_install ${packages[@]}
    if ! ip link show "$device" &>/dev/null; then
        echo "Error: Network interface '$device' not found."
        return 1
    fi

    NAME=$(nmcli -t -f NAME,DEVICE connection show | awk -F: -v dev="$device" '$2 == dev {print $1}')

    if [[ -n "$NAME" ]]; then
	sudo nmcli c modify "$NAME" 802-3-ethernet.wake-on-lan magic
	echo "Enabled WOL for $device ($NAME)"
    else
        echo "No connection found for device: $device" >&2
        return 1
    fi
}

usage() {
	echo "Usage:"
	echo "--windowmaker     Install Windowmaker"
	echo "--kde             Install KDE"
	echo "--nvidia          NVIDIA Graphics card"
	echo "--gaming          Gaming Stuff"
	echo "--aur             Enable AUR"
	echo "--haskell         Install haskell things :("
	echo "--uni             Install Uni things (mostly TeXLive)"
	echo "--wol IFACE       Enable WOL for interface IFACE"
	exit 0
}

while [[ $# -gt 0 ]] do
	case $1 in
		--windowmaker)
			windowmaker_setup
			shift
			;;
		--kde)
			kde_setup
			shift
			;;
		--gaming)
			gaming_setup
			shift
			;;
		--aur)
			aur_setup
			aur_programs
			shift
			;;
		--nvidia)
			nvidia
			shift
			;;
		--haskell)
			haskell_setup
			shift
			;;
		--uni)
			uni_setup
			shift
			;;
		--wol)
			if [[ -n "$2" ]]; then
				enable_wol "$2"
				shift 2
			else
				echo "Error: --wol requires an argument."
				usage
				exit 1
			fi
			;;
		-h|--help)
			usage
			shift
			;;
		*)
			echo "Invalid option: $1"
			usage
			;;
	esac
done

install_requirements
enable_services
