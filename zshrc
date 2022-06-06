# Environment variables

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export HOMEBREW_CASK_OPTS="--no-quarantine"

# Aliases

alias ls='ls -lAFh'
alias exa='exa -laFh --git'

# Customized prompts

RPROMPT='%*'

# ZSH Functions

function mkcd() {
	mkdir -p "$@" && cd "$_"
}

# $PATH variables

export PATH="/Users/rafaelmatsumoto/.pyenv/shims:${PATH}"
eval "$(pyenv init -)"
