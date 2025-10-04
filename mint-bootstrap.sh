#!/usr/bin/env bash


set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() {
    echo -e "${GREEN}==>${NC} ${1}"
}

warn() {
    echo -e "${YELLOW}==> WARNING:${NC} ${1}"
}

# Update package index
info "Updating package lists..."
sudo apt update

# Install required base packages
info "Installing base packages: git, vim, stow..."
sudo apt install -y git vim stow

GIT_NAME="Nils"
GIT_EMAIL="40796807+uchars@users.noreply.github.com"
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# Clone dotfiles
DOTFILES_DIR="$HOME/.files"
if [ -d "$DOTFILES_DIR" ]; then
    warn "$DOTFILES_DIR already exists. Skipping clone."
else
    info "Cloning dotfiles into $DOTFILES_DIR..."
    git clone https://github.com/uchars/.files "$DOTFILES_DIR"
fi

# Remove existing bashrc and profile
info "Removing existing ~/.bashrc and ~/.profile (if any)..."
rm -f ~/.bashrc ~/.profile

# Apply stow symlinks
info "Stowing dotfiles..."
cd "$DOTFILES_DIR"
stow .

# Add Yubico PPA and install YubiKey tools
info "Adding Yubico PPA..."
sudo add-apt-repository -y ppa:yubico/stable
sudo apt update

info "Installing yubikey-manager-qt and yubioath-desktop..."
sudo apt install -y yubikey-manager-qt yubioath-desktop

# Clone and install Neovim master
info "Installing latest Neovim from master branch..."

NVIM_DIR="$HOME/.local/src/neovim"
NVIM_BIN_DIR="$HOME/.local/bin/nvim/bin"
mkdir -p "$NVIM_DIR"

if [ -d "$NVIM_DIR" ]; then
    warn "$NVIM_DIR already exists. Pulling latest changes."
    cd "$NVIM_DIR"
    git pull
else
    info "Cloning Neovim..."
    git clone https://github.com/neovim/neovim.git "$NVIM_DIR"
    cd "$NVIM_DIR"
fi

info "Building Neovim..."
make CMAKE_BUILD_TYPE=RelWithDebInfo

info "Installing Neovim to $NVIM_BIN_DIR..."
make install PREFIX="$HOME/.local/bin/nvim"

info "Bootstrap complete. You may need to restart your terminal session."

# Install Rust
log "Installing Rust via rustup..."

if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    log "Rust installed."
else
    log "Rust is already installed. Skipping."
fi

