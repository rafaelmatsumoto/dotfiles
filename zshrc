# Environment variables

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export HOMEBREW_CASK_OPTS="--no-quarantine"

# Aliases

alias ls='ls -lAFh'
alias exa='exa -laFh --git'
alias bbd='brew bundle dump --force --describe --verbose'
alias trail='<<<${(F)path}'

# Customized prompts

RPROMPT='%*'

# ZSH Functions

function mkcd() {
	mkdir -p "$@" && cd "$_"
}

# $PATH variables

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

export PATH="/Users/rafaelmatsumoto/.pyenv/shims:${PATH}"
eval "$(pyenv init -)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
