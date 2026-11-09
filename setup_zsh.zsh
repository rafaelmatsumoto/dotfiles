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

SH_LINK="/private/var/select/sh"
if [ "$(readlink "$SH_LINK")" = "$ZSH_PATH" ]; then
    echo "✓ $SH_LINK already linked to $ZSH_PATH"
else
    echo "Symlinking $SH_LINK to $ZSH_PATH..."
    # -n: never prompt for a password (this script also runs non-interactively via dotbot)
    if sudo -n ln -sf "$ZSH_PATH" "$SH_LINK" 2>/dev/null; then
        echo "✓ $SH_LINK linked to $ZSH_PATH"
    else
        echo "✗ Could not update $SH_LINK (sudo requires an interactive terminal)." >&2
        echo "  Run this manually once:" >&2
        echo "    sudo ln -sf $ZSH_PATH $SH_LINK" >&2
        exit 1
    fi
fi

