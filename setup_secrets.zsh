#!/usr/bin/env zsh

set -e

echo "=== Secrets Setup ==="
echo "This script helps set up your local environment variables."

ZSENV_LOCAL="$HOME/.zshenv.local"
TEMPLATE=".zshenv.local.template"

if [[ -f "$ZSENV_LOCAL" ]]; then
    echo "✓ $ZSENV_LOCAL already exists"
    echo "Current size: $(wc -l < "$ZSENV_LOCAL") lines"
    
    read -q "REPLACE? Overwrite existing file? [y/N]: "
    echo
    if [[ "$REPLACE" != "y" ]]; then
        echo "Keeping existing file."
        exit 0
    fi
fi

if [[ ! -f "$TEMPLATE" ]]; then
    echo "✗ Template file $TEMPLATE not found" >&2
    exit 1
fi

echo "Copying template to $ZSENV_LOCAL..."
cp "$TEMPLATE" "$ZSENV_LOCAL"

if [[ -f "$ZSENV_LOCAL" ]]; then
    echo "✓ Created $ZSENV_LOCAL"
    echo ""
    echo "Next steps:"
    echo "1. Edit the file with your secrets:"
    echo "   nvim $ZSENV_LOCAL"
    echo "   or"
    echo "   code $ZSENV_LOCAL"
    echo ""
    echo "2. Common things to configure:"
    echo "   - Git name/email"
    echo "   - GitHub token"
    echo "   - AWS credentials"
    echo "   - API keys for services you use"
    echo ""
    echo "3. The file is automatically sourced by ~/.zshenv"
    echo "   Open a new terminal to test: echo \$GITHUB_TOKEN"
else
    echo "✗ Failed to create $ZSENV_LOCAL" >&2
    exit 1
fi