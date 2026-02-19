# AI Agent Configuration

This document describes the AI agent setup and workflows integrated into these dotfiles.

## OpenCode

OpenCode is an AI coding agent built for the terminal, installed via Homebrew and integrated with a custom `work()` function for git worktree management.

### Installation

OpenCode is installed via Homebrew from the anomalyco/tap:

```bash
brew install anomalyco/tap/opencode
```

The package is already included in the `Brewfile` at line 73:

```ruby
# The AI coding agent built for the terminal.
brew "anomalyco/tap/opencode"
```

### Usage

The primary interface to OpenCode is through the `work()` function defined in `zshrc:64`:

```bash
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
```

#### Basic Workflow

1. **Create a new branch and OpenCode session**:
   ```bash
   work feature-branch-name
   ```

2. **What happens**:
   - Creates a new git branch `feature-branch-name`
   - Creates a worktree at `../worktrees/feature-branch-name/`
   - Opens a new tmux window named `OC-feature-branch-name`
   - Starts OpenCode in the worktree directory

3. **To exit OpenCode**:
   - Type `/quit` within OpenCode
   - Or use tmux commands to close the window

### Advanced Workflow: Tmux Integration

The `tmux.conf` includes special enhancements for worktree management (`tmux.conf:37-47`):

1. **Dynamic Status Bar**: Shows the Git branch of the active worktree in the tmux status bar
   - Updates every 5 seconds
   - Displays current session and git branch

2. **"Nuke" Shortcut**: `Prefix + X` (where prefix is `C-a`)
   - Kills the current tmux window
   - Attempts to remove the associated git worktree
   - Prompts for confirmation before executing
   - Assumes worktrees are in `../worktrees/` relative to main repo

Example workflow:
```bash
work my-feature          # Creates branch, worktree, and OpenCode session
# Work in OpenCode...
# When done: Prefix + X to kill window and cleanup worktree
```

### Configuration

OpenCode configuration can be found in its own configuration directory (typically `~/.config/opencode/`). Refer to the [OpenCode documentation](https://opencode.ai) for advanced configuration options.

## Personal Preferences & Workflows

Based on your dotfiles configuration, here are some identified preferences and workflows:

### Development Environment

- **Shell**: Zsh with zplug plugin manager
- **Editor**: Neovim with lazy.nvim package manager (`vim` alias points to `nvim`)
- **File Listing**: `eza` instead of `ls` (`l` alias: `eza -la --classify --git`)
- **File Viewing**: `bat` instead of `cat` (`cat` alias points to `bat`)
- **Terminal Multiplexer**: Tmux with TPM plugin manager
- **Fuzzy Finder**: `fzf` integrated with shell

### Git Preferences

- **Default Branch**: `main` (`gitconfig:6`)
- **Commit Signing**: Enabled with SSH keys (`gitconfig:8`)
- **Signing Tool**: 1Password SSH agent (`gitconfig:12`)
- **User Configuration**:
  ```gitconfig
  name = Rafael Matsumoto
  email = 37717679+rafaelmatsumoto@users.noreply.github.com
  signingkey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFsWqYp0QoV3/u2f8Ys5AeNHArEBYzBMOphBk24j0Hzj GitHub
  ```

### Language & Tool Management

- **Python**: `pyenv` for version management
- **Node.js**: `nvm` for version management  
- **Java/Scala**: `sdkman` for version management
- **Package Managers**:
  - `poetry` for Python
  - `brew` for macOS packages
  - `pre-commit` for git hooks

### Security & Secrets

- **Password Manager**: 1Password with SSH agent integration
- **Secrets Management**: `~/.zshenv.local` for environment variables (see `.zshenv.local.template`)
- **Git Security**: `gitleaks` for secret scanning in commits
- **SSH Agent**: 1Password container socket (`~/.zshenv:26`)

### Terminal & UI Preferences

- **Theme**: oh-my-zsh "candy" theme (`zshrc:36`)
- **Syntax Highlighting**: `zsh-syntax-highlighting`
- **Vi Mode**: `zsh-vi-mode` for vi keybindings in shell
- **Autosuggestions**: `zsh-autosuggestions` via Homebrew
- **Man Pages**: `bat` as man pager (`zshrc:8`)
- **Tmux**: Plugins for session persistence (`tmux-resurrect`, `tmux-continuum`)

### Workflow Automation

- **Notes System**: `notes` command alias for personal documentation (`zshrc:18`)
- **Quick Directory Creation**: `mkcd()` function creates directory and enters it (`zshrc:24`)
- **Brew Bundle Management**: `bbd` alias for dumping installed packages (`zshrc:16`)
- **Path Inspection**: `trail` alias shows `$PATH` components (`zshrc:17`)

## Integration Points for AI Agents

### OpenCode-Specific

1. **Worktree Organization**: Worktrees are created in `../worktrees/` relative to the main repository
2. **Tmux Integration**: Each OpenCode session gets its own tmux window with branch name, plus enhanced status bar showing git branch and "Nuke" shortcut (`Prefix + X`) for cleanup
3. **Isolation**: Each branch gets its own directory, keeping changes separate

### Potential Future Integrations

Consider integrating these tools with your AI workflow:

1. **GitHub Copilot CLI**: Could be added to Brewfile and aliased
2. **Cursor Rules**: If using Cursor editor, add configuration files
3. **Continue.dev**: Another AI coding assistant with local models
4. **Windsurf**: VS Code-based AI editor

## Troubleshooting

### OpenCode Issues

- **Command not found**: Ensure Homebrew installation completed: `brew install anomalyco/tap/opencode`
- **Tmux errors**: Verify tmux is running before using `work()` command
- **Git worktree errors**: Check git version and permissions

### General AI Agent Tips

1. **Context Window**: Larger context windows work better with more code in view
2. **Temperature**: Lower temperatures (0.1-0.3) for precise code generation
3. **Iterative Refinement**: Break complex tasks into smaller prompts
4. **Code Review**: Always review AI-generated code before committing

## Updates

### Update OpenCode

```bash
brew update
brew upgrade opencode
```

### Update All Agents

Check for updates to all AI-related tools in Brewfile and update as needed.

## References

- [OpenCode Documentation](https://opencode.ai)
- [Git Worktree Documentation](https://git-scm.com/docs/git-worktree)
- [Tmux Documentation](https://github.com/tmux/tmux/wiki)
- [zplug Documentation](https://github.com/zplug/zplug)