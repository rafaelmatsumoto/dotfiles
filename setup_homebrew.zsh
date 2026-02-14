#!/usr/bin/env zsh

set -e

echo "\n<<< Starting Homebrew Setup >>>\n"

if command -v brew &>/dev/null; then
    echo "✓ Homebrew already installed"
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    if command -v brew &>/dev/null; then
        echo "✓ Homebrew installed successfully"
    else
        echo "✗ Homebrew installation failed" >&2
        exit 1
    fi
fi

echo "Installing packages from Brewfile..."
if brew bundle --verbose; then
    echo "✓ Brew bundle completed successfully"
else
    echo "✗ Brew bundle failed" >&2
    exit 1
fi
