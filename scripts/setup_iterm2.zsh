#!/usr/bin/env zsh

set -e

echo "=== iTerm2 Setup ==="

ITerm2_CONFIG="$HOME/.config/iterm2-config/com.googlecode.iterm2.plist"
ITerm2_APP="/Applications/iTerm.app"

# Check if iTerm2 is installed
if [[ ! -d "$ITerm2_APP" ]]; then
    echo "iTerm2 not found at $ITerm2_APP"
    echo "Please install iTerm2 first: brew install --cask iterm2"
    exit 1
fi

# Check if config file exists
if [[ ! -f "$ITerm2_CONFIG" ]]; then
    echo "iTerm2 config file not found: $ITerm2_CONFIG"
    echo "Make sure dotfiles are installed and config is linked"
    exit 1
fi

echo "Configuring iTerm2..."

# Method 1: Use defaults command (simpler but limited)
# defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/.config/iterm2-config"
# defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# Method 2: Copy plist to iTerm2's preferences location
ITerm2_PREFS="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
if [[ -f "$ITerm2_PREFS" ]]; then
    echo "Backing up existing iTerm2 preferences..."
    cp "$ITerm2_PREFS" "$ITerm2_PREFS.backup.$(date +%Y%m%d_%H%M%S)"
fi

echo "Installing iTerm2 configuration..."
cp "$ITerm2_CONFIG" "$ITerm2_PREFS"

# Method 3: AppleScript for more control (optional)
cat > /tmp/setup_iterm2.applescript << 'EOF'
tell application "iTerm2"
    activate
    
    # Wait for iTerm2 to start
    delay 2
    
    # Set preferences to use custom folder
    tell current session of current window
        write text "echo 'iTerm2 configuration applied'"
    end tell
end tell
EOF

# echo "To apply changes, restart iTerm2 or run:"
# echo "  defaults read com.googlecode.iterm2.plist"

echo "✓ iTerm2 configuration copied"
echo "Note: Restart iTerm2 for changes to take effect"