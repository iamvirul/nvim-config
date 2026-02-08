#!/bin/bash
set -e

echo "=== Neovim Config Installer ==="
echo ""

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"

install_brew() {
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add brew to PATH for this session
        if [ -f /opt/homebrew/bin/brew ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -f /usr/local/bin/brew ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        echo "Homebrew already installed"
    fi
}

install_macos() {
    install_brew
    echo "Installing Neovim..."
    brew install neovim
    echo "Installing dependencies..."
    brew install ripgrep git
    echo "Installing Java 21..."
    brew install openjdk@21
    echo "Installing Nerd Font..."
    brew install --cask font-jetbrains-mono-nerd-font
}

install_linux() {
    if command -v apt-get &>/dev/null; then
        echo "Detected Debian/Ubuntu"
        sudo apt-get update
        sudo apt-get install -y git ripgrep curl

        # Install latest Neovim via GitHub release
        echo "Installing Neovim..."
        NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz"
        curl -fsSL "$NVIM_URL" -o /tmp/nvim.tar.gz
        sudo tar -xzf /tmp/nvim.tar.gz -C /opt
        sudo ln -sf /opt/nvim-linux-${ARCH}/bin/nvim /usr/local/bin/nvim
        rm /tmp/nvim.tar.gz

        # Install Java
        echo "Installing Java 21..."
        sudo apt-get install -y openjdk-21-jdk

    elif command -v dnf &>/dev/null; then
        echo "Detected Fedora/RHEL"
        sudo dnf install -y neovim git ripgrep java-21-openjdk-devel

    elif command -v pacman &>/dev/null; then
        echo "Detected Arch Linux"
        sudo pacman -S --noconfirm neovim git ripgrep jdk21-openjdk

    else
        echo "Unsupported Linux distro. Install manually: neovim, git, ripgrep, java 21"
        exit 1
    fi
}

# Install based on OS
case "$OS" in
    Darwin) install_macos ;;
    Linux)  install_linux ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Clone config
NVIM_DIR="$HOME/.config/nvim"
if [ -d "$NVIM_DIR" ]; then
    echo ""
    echo "Existing config found at $NVIM_DIR"
    read -p "Back it up and replace? (y/n): " choice
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        BACKUP="$NVIM_DIR.bak.$(date +%s)"
        mv "$NVIM_DIR" "$BACKUP"
        echo "Backed up to $BACKUP"
    else
        echo "Aborted. Remove or move $NVIM_DIR manually and re-run."
        exit 0
    fi
fi

echo "Cloning config..."
git clone https://github.com/iamvirul/nvim-config.git "$NVIM_DIR"

echo ""
echo "=== Done! ==="
echo "Run 'nvim' to launch. Plugins will auto-install on first start."
echo "Run ':Mason' to check LSP status, ':Lazy' to check plugins."
