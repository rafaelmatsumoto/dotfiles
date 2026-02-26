# Misc

setopt autocd

# Environment variables

export ZPLUG_HOME="/opt/homebrew/opt/zplug"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export HOMEBREW_CASK_OPTS="--no-quarantine"
export ATUIN_HOST="https://atuin.rafaelmatsumoto.space"
export ATUIN_USERNAME="rafael"
# eval "$(atuin init zsh)" moved to end of file

# Aliases

alias l='eza -la --classify --git'
alias vim='nvim'
alias cat="bat"
alias bbd='brew bundle dump --force --describe --verbose'
alias trail='<<<${(F)path}'
alias notes='~/.dotfiles/scripts/notes'

# Customized prompts

# ZSH Functions

function mkcd() {
	mkdir -p "$@" && cd "$_"
}

# $PATH variables

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zplug configuration

source $ZPLUG_HOME/init.zsh

zplug "themes/candy", from:oh-my-zsh, as:theme
zplug "zsh-users/zsh-syntax-highlighting", from:github, defer:3
zplug "jeffreytse/zsh-vi-mode"

# Actually install plugins, prompt user input
if ! zplug check --verbose; then
    printf "Install zplug plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

export PATH="/Users/rafaelmatsumoto/.pyenv/shims:${PATH}"
eval "$(pyenv init -)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Disable fzf's Ctrl+R to let Atuin handle it
bindkey -r "^R"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Git Worktree + Tmux Orchestrator
work() {
    local branch_name=$1
    # This puts worktrees in a folder next to your main 'perigee' folder
    local worktree_path="../worktrees/$branch_name"

    if [ -z "$branch_name" ]; then
        echo "Usage: work <branch-name>"
        return 1
    fi

    echo "Creating branch and worktree for: $branch_name"
    
    # 1. Create the branch and the worktree folder
    git worktree add -b "$branch_name" "$worktree_path"

    # 2. Open a new tmux window, name it, and start OpenCode
    # We use 'C-a' because of your specific tmux.conf mapping
    tmux new-window -n "OC-$branch_name" -c "$worktree_path" "opencode"
}

eval "$(atuin init zsh)"
