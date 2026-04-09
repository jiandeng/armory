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

# 6. Install Zephyr SDK (v0.17.4)
ZEPHYR_SDK_VERSION="0.17.4"
ZEPHYR_SDK_DIR="$HOME/.local/opt/zephyr-sdk-$ZEPHYR_SDK_VERSION"
ZEPHYR_SDK_URL="https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/zephyr-sdk-${ZEPHYR_SDK_VERSION}_macos-aarch64_minimal.tar.xz"

if [ ! -d "$ZEPHYR_SDK_DIR" ]; then
    echo "📦 Downloading and extracting Zephyr SDK v$ZEPHYR_SDK_VERSION..."
    mkdir -p "$HOME/.local/opt"
    # Using curl | tar to save disk space for the intermediate archive
    curl -L "$ZEPHYR_SDK_URL" | tar -xJ -C "$HOME/.local/opt"
    echo "🔄 Running Zephyr SDK setup..."
    if [ -f "$ZEPHYR_SDK_DIR/setup.sh" ]; then
        (cd "$ZEPHYR_SDK_DIR" && ./setup.sh -t arm-zephyr-eabi)
    else
        echo "❌ Error: Zephyr SDK setup.sh was not found!"
    fi
else
    echo "✅ Zephyr SDK v$ZEPHYR_SDK_VERSION is already installed."
fi

# 7. Create/Update symlink for Single Source of Truth
echo "🔗 Updating Zephyr SDK symlink..."
ln -sfn "$ZEPHYR_SDK_DIR" "$HOME/.local/opt/zephyr-sdk"

# 8. Final confirmation
echo "✅ Bootstrap complete! Please restart your terminal."
