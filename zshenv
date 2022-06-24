echo "Hello from .zshenv"

function exists() {
    # command is similar to which, but a little more compliant
	command -v $1 >/dev/null 2>&1
}
