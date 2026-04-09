#!/usr/bin/env bash

set -e

echo "🚀 Bootstrapping Embedded Development Environment for Apple Silicon..."

# 1. Install Homebrew (if not installed)
if ! command -v brew >/dev/null 2>&1; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew is already installed."
fi

# Load brew env temporarily
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Install chezmoi
if ! command -v chezmoi >/dev/null 2>&1; then
    echo "📦 Installing chezmoi..."
    brew install chezmoi
else
    echo "✅ chezmoi is already installed."
fi

# 3. Setup chezmoi directory
CHEZMOI_SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "🔄 Current source directory: $CHEZMOI_SRC_DIR"

if [ -d "$CHEZMOI_SRC_DIR" ]; then
    echo "🔄 Initializing chezmoi with source: $CHEZMOI_SRC_DIR"
    # Execute apply specifically from this source to ensure ~/ dotfiles are created
    # Note: We NO LONGER use 'chezmoi add' here to prevent pulling in old/broken local configs.
    chezmoi apply --source "$CHEZMOI_SRC_DIR" --force
else
    echo "❌ Error: Source directory not found!"
    exit 1
fi

# 4. Install Brewfile dependencies
echo "📦 Installing dependencies from Brewfile..."
brew bundle --file="$CHEZMOI_SRC_DIR/Brewfile"

# 5. Install nrfutil plugins (sdk-manager, device, etc.)
echo "🛠️ Installing nrfutil plugins..."
if command -v nrfutil >/dev/null 2>&1; then
    # Ensure toolchain manager is ready
    nrfutil install trace mcu-manager device sdk-manager ble-sniffer npm suit completion 91 nrf5sdk-tools --force
else
    echo "⚠️ Warning: nrfutil not found, skipping plugin installation."
fi

# 6. Final confirmation
echo "✅ Bootstrap complete! Please restart your terminal."
