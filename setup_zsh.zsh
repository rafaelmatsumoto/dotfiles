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

# /private/var/select/sh decides what /bin/sh re-execs as. The macOS sh shim
# only recognises /bin/bash, /bin/dash and /bin/zsh -- Homebrew's zsh path is
# not accepted.
#
# This link is owned by macOS Directory Services and gets reset to /bin/bash
# when the service reconciles, so treat it as best effort: it is a cosmetic
# convenience and must never fail the dotbot install. The login shell set
# above via `chsh` is the part that actually matters.
SH_LINK="/private/var/select/sh"
SH_TARGET="/bin/zsh"
if [ "$(readlink "$SH_LINK")" = "$SH_TARGET" ]; then
    echo "✓ $SH_LINK already linked to $SH_TARGET"
elif sudo -n ln -sf "$SH_TARGET" "$SH_LINK" 2>/dev/null; then
    echo "✓ $SH_LINK linked to $SH_TARGET"
else
    echo "→ $SH_LINK points to $(readlink "$SH_LINK" 2>/dev/null || echo 'unset'); macOS may reset it."
    echo "  To make /bin/sh use zsh, run once:"
    echo "    sudo ln -sf $SH_TARGET $SH_LINK"
fi

