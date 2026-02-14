#!/usr/bin/env zsh

set -e

echo "\n<<< Starting ZSH Setup >>>\n"

ZSH_PATH="/opt/homebrew/bin/zsh"

if ! grep -q "$ZSH_PATH" '/etc/shells'; then
    echo "Adding $ZSH_PATH to /etc/shells..."
    echo "$ZSH_PATH" | sudo tee -a '/etc/shells' >/dev/null
    if grep -q "$ZSH_PATH" '/etc/shells'; then
        echo "✓ $ZSH_PATH added to /etc/shells"
    else
        echo "✗ Failed to add $ZSH_PATH to /etc/shells" >&2
        exit 1
    fi
else
    echo "✓ $ZSH_PATH already in /etc/shells"
fi

if [ "$SHELL" = "$ZSH_PATH" ]; then
    echo "✓ Login shell already set to $ZSH_PATH"
else
    echo "Changing login shell to $ZSH_PATH..."
    if chsh -s "$ZSH_PATH"; then
        echo "✓ Login shell changed to $ZSH_PATH"
        echo "Note: Changes take effect after restarting your terminal"
    else
        echo "✗ Failed to change login shell" >&2
        exit 1
    fi
fi

if sh --version 2>/dev/null | grep -q zsh; then
    echo "✓ /private/var/select/sh already linked to zsh"
else
    echo "Symlinking /private/var/select/sh to /bin/zsh..."
    if sudo ln -sf /bin/zsh /private/var/select/sh; then
        echo "✓ /private/var/select/sh linked to /bin/zsh"
    else
        echo "✗ Failed to symlink /private/var/select/sh" >&2
        exit 1
    fi
fi

