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
# --no-upgrade is essential: without it `brew bundle` upgrades casks that
# Homebrew considers outdated, and the cask upgrade path needs sudo to move
# the app into /Applications. Run non-interactively (as dotbot does) that
# sudo prompt fails, leaving the app DELETED and a stale *.upgrading dir in
# the Caskroom. This bit Google Chrome and Discord.
# Auto-updating casks update themselves; formulae are upgraded on demand
# with `brew upgrade`.
if brew bundle --no-upgrade --verbose; then
    echo "✓ Brew bundle completed successfully"
else
    echo "✗ Brew bundle failed" >&2
    exit 1
fi
