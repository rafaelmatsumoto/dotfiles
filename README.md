# Dotfiles

Personal dotfiles managed with [dotbot](https://github.com/anishathalye/dotbot).

## Quick Start

### Prerequisites
- macOS (tested on macOS Sonoma 14+)
- Git
- Zsh (installed by default on macOS)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/rafaelmatsumoto/.dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the install script:**
   ```bash
   ./install
   ```

3. **Set up secrets (optional but recommended):**
   ```bash
   ./setup_secrets.zsh
   # Then edit ~/.zshenv.local with your API keys and secrets
   ```

4. **Restart your terminal** or source the new configuration:
   ```bash
   source ~/.zshrc
   ```

## What Gets Installed

### Configuration Files
- `~/.zshrc` - Zsh configuration with zplug plugin manager
- `~/.zshenv` - Environment variables and utility functions
- `~/.gitconfig` - Git configuration with user details
- `~/.tmux.conf` - Tmux configuration with TPM plugin manager
- `~/.config/bat/config` - Bat (cat clone) configuration
- `~/.config/nvim/` - Neovim configuration
- `~/.config/iterm2-config/` - iTerm2 configuration

### Homebrew Packages
All packages are defined in `Brewfile` and installed via `brew bundle`:
- **Core utilities**: bat, eza, fd, fzf, gh
- **Development tools**: awscli, pyenv, nvm, sdkman
- **Neovim** with lazy.nvim package manager

### Shell Setup
- **Zsh** as default shell
- **zplug** plugin manager with:
  - oh-my-zsh candy theme
  - zsh-syntax-highlighting
  - zsh-vi-mode
- **zsh-autosuggestions** via Homebrew

## Automated Setup

Most setup is automated during installation:

### Tmux Plugins
- **TPM (Tmux Plugin Manager)** automatically installed
- **Plugins** automatically installed on first run:
  - `tmux-sensible` - sensible defaults
  - `tmux-resurrect` - session persistence
  - `tmux-continuum` - automatic session saving

## Manual Steps (if needed)

### iTerm2 Configuration
For automated iTerm2 setup:
```bash
./scripts/setup_iterm2.zsh
```

Or manually:
1. Open iTerm2
2. Go to Preferences > Profiles > General
3. Click "Other actions..." > Import JSON Profiles
4. Select `~/.config/iterm2-config/com.googlecode.iterm2.plist`
5. Set as default if desired

### Neovim Setup
Neovim uses [lazy.nvim](https://github.com/folke/lazy.nvim) package manager:
```bash
nvim  # First run will install plugins automatically
```

### Manual Tmux Plugin Management
If plugins don't auto-install:
```bash
./scripts/setup_tmux_plugins.zsh
```

Or in tmux:
- `Prefix + I` - Install plugins
- `Prefix + U` - Update plugins  
- `Prefix + Alt + u` - Uninstall plugins

## Project Structure

```
.dotfiles/
├── install                    # Main installation script
├── install.conf.yaml          # Dotbot configuration
├── README.md                  # This file
├── SETUP_SECRETS.md           # Secrets setup guide
├── AGENTS.md                   # AI agent configuration and workflows
├── Brewfile                   # Homebrew packages
├── Brewfile.lock.json         # Homebrew lock file (ignored)
├── .gitignore                 # Git ignore rules
├── .gitmodules                # Git submodules (dotbot)
│
├── config/                    # Application configurations
│   ├── bat/config             # Bat configuration
│   ├── nvim/                  # Neovim configuration
│   └── iterm2-config/         # iTerm2 configuration
│
├── dotbot/                    # Dotbot submodule
│
├── tmux/                      # Tmux configuration
│   └── plugins/               # Tmux Plugin Manager
│
├── scripts/                   # Custom scripts (if any)
│
└── *.zsh, *.conf, etc.        # Individual dotfiles
```

## Files

### Core Configuration
- **`zshrc`** - Main Zsh configuration with aliases, plugins, and PATH setup
- **`zshenv`** - Environment setup with secrets loading
- **`gitconfig`** - Git user configuration
- **`tmux.conf`** - Tmux key bindings and plugin configuration

### Setup Scripts
- **`setup_homebrew.zsh`** - Installs Homebrew and packages
- **`setup_zsh.zsh`** - Configures Zsh as default shell
- **`setup_secrets.zsh`** - Guides secret configuration
- **`scripts/setup_tmux_plugins.zsh`** - Installs Tmux plugins
- **`scripts/setup_iterm2.zsh`** - Configures iTerm2 (optional)

### Templates & Documentation
- **`.zshenv.local.template`** - Template for personal secrets (API keys, etc.)
- **`PERSONAL_NOTES.md`** - Personal workflows and instructions
- **`CHEATSHEET.md`** - Quick reference guide
- **`SETUP_SECRETS.md`** - Detailed secrets setup guide
- **`AGENTS.md`** - AI agent configuration and workflows

## Customization

### Adding New Dotfiles
1. Add the file to the repository root
2. Add a link in `install.conf.yaml`:
   ```yaml
   - link:
       ~/.filename: filename
   ```
3. Run `./install` to apply changes

### Adding Homebrew Packages
1. Edit `Brewfile`:
   ```ruby
   brew "package-name"
   ```
2. Run `brew bundle` or re-run `./install`

### Adding Zsh Plugins
Edit `zshrc`:
```bash
zplug "username/plugin", from:github
```

## Troubleshooting

### Installation Issues
- **Permission denied**: Ensure scripts are executable: `chmod +x install setup_*.zsh`
- **Dotbot errors**: Check `install.conf.yaml` syntax
- **Homebrew not found**: Internet connection required for first-time install

### Configuration Issues
- **Zsh plugins not loading**: Run `zplug install` manually
- **Tmux plugins not working**: Press `Prefix + I` in tmux
- **Neovim errors**: Check `~/.config/nvim/` for correct setup

### Secrets Not Loading
- Ensure `~/.zshenv.local` exists and is readable
- Check `zshenv` sources the local file correctly
- Restart terminal after creating `~/.zshenv.local`

### Git Issues
- **`.DS_Store` files appearing**: They're ignored by `.gitignore` but can be removed with `find . -name ".DS_Store" -delete`

## Updating

### Update Dotfiles
```bash
cd ~/.dotfiles
git pull
./install
```

### Update Homebrew Packages
```bash
brew update
brew upgrade
brew bundle dump --force --describe
```

### Update Zsh Plugins
```bash
zplug update
```

## Security

### Secrets Management
- **Never commit secrets** to version control
- Use `~/.zshenv.local` for API keys and sensitive data
- See `SETUP_SECRETS.md` for detailed security practices

### Git Configuration
User details are in `gitconfig` - update with your information:
```gitconfig
[user]
    name = Your Name
    email = your.email@example.com
```

## Personal Notes System

This repository includes a personal notes system for storing workflows, reminders, and instructions:

### Available Documentation
- **`PERSONAL_NOTES.md`** - Detailed personal workflows and instructions
- **`CHEATSHEET.md`** - Quick reference for commands and key bindings
- **`SETUP_SECRETS.md`** - Complete guide for secrets management
- **`AGENTS.md`** - AI agent configuration and workflows

### Access Notes
```bash
# Use the notes command (alias in zshrc)
notes

# Or view directly
bat PERSONAL_NOTES.md
cat CHEATSHEET.md
bat AGENTS.md
```

### Adding Personal Notes
Edit the markdown files directly or create new files in the repository root.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Dotbot](https://github.com/anishathalye/dotbot) for dotfiles management
- [Homebrew](https://brew.sh/) for package management
- [zplug](https://github.com/zplug/zplug) for Zsh plugin management
- [TPM](https://github.com/tmux-plugins/tpm) for Tmux plugin management