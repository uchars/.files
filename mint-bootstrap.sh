#!/usr/bin/env bash

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
GREY='\033[0;90m'
NC='\033[0m'

DEBUG=0
DEV=0
VERBOSE=0

for arg in "$@"; do
    case $arg in
        -v|--verbose)
            DEBUG=1
            shift
            ;;
        -d|--dev)
            DEV=1
            shift
            ;;
    esac
done

debug() {
    if [ "$DEBUG" -eq 1 ]; then
	echo -e "${GREY}==> DEBUG:${NC} ${1}"
    fi
}

info() {
    echo -e "${GREEN}==> INFO:${NC} ${1}"
}

warn() {
    echo -e "${YELLOW}==> WARNING:${NC} ${1}"
}

cmd() {
    if [ "$DEV" -eq 1 ]; then
        echo "[DEV] $@"
    elif [ "$DEBUG" -eq 1 ]; then
        echo "+ $*"
        "$@"
    else
	"$@" >/dev/null 2>&1
    fi
}

# Update package index
info "Updating package lists..."
cmd sudo apt update >/dev/null

# Install required base packages
info "Installing base packages: git, vim, stow..."
cmd sudo apt install -y git vim stow cmake

GIT_NAME="Nils"
GIT_EMAIL="40796807+uchars@users.noreply.github.com"
cmd git config --global user.name "$GIT_NAME"
cmd git config --global user.email "$GIT_EMAIL"

# Clone dotfiles
DOTFILES_DIR="$HOME/.files"
if [ -d "$DOTFILES_DIR" ]; then
    warn "$DOTFILES_DIR already exists. Skipping clone."
else
    debug "Cloning dotfiles into $DOTFILES_DIR..."
    cmd git clone -q https://github.com/uchars/.files "$DOTFILES_DIR"
fi

# Remove existing bashrc and profile
debug "Removing existing ~/.bashrc and ~/.profile (if any)..."
cmd rm -f ~/.bashrc ~/.profile

# Apply stow symlinks
debug "Stowing dotfiles..."
cmd cd "$DOTFILES_DIR"
cmd stow .

info "Installing dependencies from deb-requirements.txt"
cmd xargs sudo apt install -y < "$DOTFILES_DIR/deb-requirements.txt"

# Add Yubico PPA and install YubiKey tools
debug "Adding Yubico PPA..."
cmd sudo add-apt-repository -y ppa:yubico/stable
cmd sudo apt update

debug "Installing yubikey-manager-qt and yubioath-desktop..."
cmd sudo apt install -y yubikey-manager-qt yubioath-desktop

# Clone and install Neovim master
info "Installing latest Neovim from master branch..."

NVIM_DIR="$HOME/.local/src/neovim"
NVIM_BIN_DIR="$HOME/.local/bin/nvim/bin"
mkdir -p "$NVIM_DIR"

if [ -d "$NVIM_DIR/.git" ]; then
    debug "Neovim repo already exists. Pulling latest changes..."
    cd "$NVIM_DIR"
    cmd git pull -q
else
    debug "Cloning Neovim into $NVIM_DIR..."
    cmd git clone -q https://github.com/neovim/neovim.git "$NVIM_DIR"
    cd "$NVIM_DIR"
fi

debug "Building Neovim..."
cmd make CMAKE_BUILD_TYPE=RelWithDebdebug
cmd sudo make install
debug "Neovim Installed"

# Install Rust
info "Installing Rust via rustup..."

if ! command -v rustup >/dev/null 2>&1; then
    cmd curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    debug "Rust installed."
else
    debug "Rust is already installed. Skipping."
fi

info "Flatpak installs"
cmd flatpak install -y flathub com.usebottles.bottles
cmd flatpak install -y flathub com.discordapp.Discord

info "Installing NVM (Node Version Manager)..."
if [ ! -d "$HOME/.nvm" ]; then
    cmd curl -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
else
    debug "NVM already installed. Skipping download."
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
debug "Installing latest LTS version of Node.js (includes npm)..."
cmd nvm install --lts
debug "Setting default Node.js version to LTS..."
cmd nvm alias default 'lts/*'
debug "Node.js and npm installed via NVM."

info "Install KVM..."
cmd sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager -y
cmd sudo usermod -aG libvirt $(whoami)
cmd sudo usermod -aG kvm $(whoami)
debug "KVM installed"

info "Installing Nerd Fonts..."
FONT_NAME="FiraCode"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if ! fc-list | grep -qi "${FONT_NAME// /} Nerd Font"; then
    info "$FONT_NAME Nerd Font already installed. Skipping."
else
    tmpfile=$(mktemp)
    cmd wget -q -O "$tmpfile" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"
    cmd unzip -qo "$tmpfile" -d "$FONT_DIR"
    cmd rm "$tmpfile"
    cmd fc-cache -f >/dev/null
    debug "$FONT_NAME Nerd Font installed successfully."
fi
debug "Nerd Fonts installed."

info "Bootstrap complete. You may need to restart your terminal session."

