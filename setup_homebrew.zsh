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
# --no-upgrade keeps the bootstrap idempotent: it installs what the Brewfile
# specifies without also upgrading anything. The self-updating casks are
# pinned in the Brewfile, so `brew bundle` never moves them into
# /Applications -- that path needs sudo, and a non-interactive sudo prompt
# fails, which would leave the app deleted from /Applications.
# Upgrade on demand with `brew upgrade`.
if brew bundle --no-upgrade --verbose; then
    echo "✓ Brew bundle completed successfully"
else
    echo "✗ Brew bundle failed" >&2
    exit 1
fi
