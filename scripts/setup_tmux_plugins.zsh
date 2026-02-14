#!/usr/bin/env zsh

set -e

echo "=== Tmux Plugin Setup ==="

TPM_DIR="$HOME/.tmux/plugins/tpm"
TMUX_CONF="$HOME/.tmux.conf"

# Check if tmux.conf exists
if [[ ! -f "$TMUX_CONF" ]]; then
    echo "✗ tmux.conf not found at $TMUX_CONF"
    exit 1
fi

# Install TPM if not present
if [[ ! -d "$TPM_DIR" ]]; then
    echo "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    
    if [[ -d "$TPM_DIR" ]]; then
        echo "✓ TPM installed"
    else
        echo "✗ TPM installation failed" >&2
        exit 1
    fi
else
    echo "✓ TPM already installed"
fi

# Install/update plugins
echo "Installing tmux plugins..."
"$TPM_DIR/bin/install_plugins"

echo "Updating tmux plugins..."
"$TPM_DIR/bin/update_plugins" all

echo "Cleaning unused plugins..."
"$TPM_DIR/bin/clean_plugins"

echo "✓ Tmux plugins setup complete"
echo ""
echo "To manually manage plugins in tmux:"
echo "  Prefix + I  # Install new plugins"
echo "  Prefix + U  # Update plugins"
echo "  Prefix + alt + u  # Uninstall plugins"