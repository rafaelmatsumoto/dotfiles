# Aliases

alias ls='ls -lAFh'

# Customized prompts

RPROMPT='%*'

# ZSH Functions

function mkcd() {
	mkdir -p "$@" && cd "$_"
}

# $PATH variables

export PATH="/Users/rafaelmatsumoto/.pyenv/shims:${PATH}"
eval "$(pyenv init -)"
