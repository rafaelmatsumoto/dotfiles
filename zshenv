function exists() {
    # Check if a command exists in PATH
    command -v "$1" >/dev/null 2>&1
}

function command_exists() {
    exists "$@"
}

# Source local environment variables (secrets, API keys, etc.)
# ============================================================
# 1. Copy .zshenv.local.template to ~/.zshenv.local
# 2. Fill in your personal secrets and configuration
# 3. This file is NOT version controlled (see .gitignore)
if [[ -f ~/.zshenv.local ]]; then
    source ~/.zshenv.local
    # echo "Loaded local environment variables from ~/.zshenv.local"
fi

# Optional: Source machine-specific configuration
if [[ -f ~/.zshenv.$(hostname -s) ]]; then
    source ~/.zshenv.$(hostname -s)
    # echo "Loaded host-specific configuration"
fi
