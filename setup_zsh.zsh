#!/usr/bin/env zsh

echo "\n<<< Starting ZSH Setup >>>\n"

if grep -Fxq '/opt/homebrew/bin/zsh' '/etc/shells'; then
	echo '/usr/local/bin/zsh already exists in /etc/shells'
else
	echo "Enter superuser (sudo) password to edit /etc/shells"
	echo '/opt/homebrew/bin/zsh' | sudo tee -a '/etc/shells' >/dev/null
fi

if [ "$SHELL" = '/opt/homebrew/bin/zsh' ]; then
	echo '$SHELL is already /opt/homebrew/bin/zsh'
else
	echo "Enter user password to change login shell"
	chsh -s '/opt/homebrew/bin/zsh'		
fi

if sh --version | grep -q zsh; then
	echo '/private/var/select/sh already linked to /bin/zsh, even though brew zsh would be prefered'
else
	echo "Enter superuser (sudo) password to symlink sh to zsh"
	sudo ln -sfv /bin/zsh /private/var/select/sh
fi

