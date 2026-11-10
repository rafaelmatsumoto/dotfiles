# AI Agent Configuration

This document describes the AI agent setup and workflows integrated into these dotfiles.

## OpenCode

OpenCode is an AI coding agent built for the terminal, installed via Homebrew and integrated with a custom `work()` function for git worktree management.

This setup runs **OpenCode V2** (`opencode-v2`). V1 and V2 share the `opencode` command but are not installed side by side; see the [V1 to V2 migration guide](https://opencode.ai/docs/migrate-v1) for what changed.

### Installation

OpenCode is installed via Homebrew from the anomalyco/tap:

```bash
brew install anomalyco/tap/opencode-v2
```

The package is already included in the `Brewfile` at line 77:

```ruby
# The AI coding agent built for the terminal.
brew "anomalyco/tap/opencode-v2"
```

> Note: the V1 formula `anomalyco/tap/opencode` conflicts with V2 over the `opencode` binary and cannot be symlinked. Never install both.

### Usage

The primary interface to OpenCode is through the `work()` function defined in `zshrc:69`:

```bash
work() {
    local branch_name=$1
    # This puts worktrees in a sibling 'worktrees/' folder next to the main repo
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
   - Or press `Ctrl+C`, `Ctrl+D`, or `Ctrl+X` then `Q` (the `app.exit` keybind; the leader key is `Ctrl+X` by default)
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

OpenCode configuration lives in `~/.config/opencode/`. V2 splits it into **two separate files** with different owners:

| File | Scope | Contents |
|------|-------|----------|
| `~/.config/opencode/opencode.json(c)` | Server + project | `model`, `default_agent`, `permissions`, `agents`, `commands`, `plugins`, `providers`, `mcp`, `skills`, `instructions`, `references`, `formatter`, `lsp` |
| `~/.config/opencode/cli.json` | Terminal client only | themes, keybinds, input, sessions, tabs, diffs, alerts, Mini, terminal plugins, debugging |

The terminal client owns `cli.json`; the background service does not load it. There is no project-local CLI configuration.

- **Keybinds** live in `cli.json` under `keybinds`. The leader key is `keybinds.leader` (default `ctrl+x`); `<leader>` in another binding refers to it. Disable a binding with `"none"` or `false`. See the [keybind reference](https://opencode.ai/docs/cli/keybinds) for valid command IDs — never guess one.
- **Config changes apply without a restart.** OpenCode watches config files and reloads agents, commands, skills, MCP servers, and plugins after a save. Use `opencode reload` to force a full reload.
- **Project config** can live as `opencode.json(c)` or `.opencode/opencode.json(c)` in the project. Discovery walks from the current directory up to the filesystem root and merges outermost-first; `.opencode/` documents override direct ones.
- Include the published schema for editor validation:
  ```jsonc
  {
    "$schema": "https://opencode.ai/config.json",
  }
  ```

### OpenCode V2 Architecture

V2 is **client-server**. The TUI, `opencode run`, and the web client all connect to a shared background service that owns sessions, configuration, plugins, permissions, and tool execution.

```bash
opencode service status     # check the background service
opencode service restart    # restart only if stuck or unhealthy
```

- OpenCode normally discovers or starts the shared service automatically.
- `--standalone` runs the TUI against a private server; `--server <url>` targets a specific one.
- `opencode serve` starts the API and web server; `opencode pair` prints one-time links (plus a QR code) to connect a browser or app.
- `opencode api GET /api/info` makes authenticated requests to the running server.

### CLI Commands

```bash
opencode                     # full-screen TUI in the current directory
opencode <directory>          # TUI in another project
opencode run "Explain this"   # one-shot prompt, prints the reply (scripts/CI)
opencode mini                # minimal interactive interface
opencode models               # list available models
opencode session list         # manage sessions (also export/delete/import)
opencode auth list            # provider credentials
opencode mcp list             # MCP servers
opencode plugin list          # installed plugins
opencode stats                # usage statistics
opencode reload               # reload config without restarting
```

Useful flags on `opencode` and `opencode run`:

- `--continue` / `-c` — continue the last session
- `--session <id>` / `-s` — continue or create a specific session
- `--prompt <text>` — prefill a prompt
- `--model`, `--agent` — pick a model or agent
- `--auto` — auto-approve permissions that are not explicitly denied
- `--standalone` / `--server <url>` — choose the server

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
- **Git Security**: `gitleaks` for secret scanning, wired as a `pre-commit` hook via `.pre-commit-config.yaml` (runs on every `git commit`)
- **SSH Agent**: 1Password container socket (`~/.zshenv:26`)
- **SSH Config**: `~/.ssh/config` is a symlink to `config/ssh/config`; personal host entries live in `~/.ssh/config.d/` and are **not** version controlled
- **OpenCode Credentials**: `~/.config/opencode/service.json` holds the local background-service password and `opencode auth export` contains provider secrets — neither is ever committed (both live outside the repo)

### Terminal & UI Preferences

- **Theme**: oh-my-zsh "candy" theme (`zshrc:39`)
- **Syntax Highlighting**: `zsh-syntax-highlighting`
- **Vi Mode**: `zsh-vi-mode` for vi keybindings in shell
- **Autosuggestions**: `zsh-autosuggestions` via Homebrew
- **Man Pages**: `bat` as man pager (`zshrc:8`)
- **Tmux**: Plugins for session persistence (`tmux-resurrect`, `tmux-continuum`)

### Workflow Automation

- **Notes System**: `notes` command alias for personal documentation (`zshrc:21`)
- **Quick Directory Creation**: `mkcd()` function creates directory and enters it (`zshrc:27`)
- **Brew Bundle Management**: `bbd` alias for dumping installed packages (`zshrc:19`)
- **Path Inspection**: `trail` alias shows `$PATH` components (`zshrc:20`)
- **Shell History**: `atuin` provides synced, fuzzy-searchable history (`Ctrl+R`) backed by `atuin.rafaelmatsumoto.space`

## Integration Points for AI Agents

### OpenCode-Specific

1. **Worktree Organization**: Worktrees are created in `../worktrees/` relative to the main repository
2. **Tmux Integration**: Each OpenCode session gets its own tmux window with branch name, plus enhanced status bar showing git branch and "Nuke" shortcut (`Prefix + X`) for cleanup
3. **Isolation**: Each branch gets its own directory, keeping changes separate
4. **Native Worktree Support**: V2 can also generate and move sessions to git worktrees from within the TUI (`dialog.worktree.generate`, `dialog.move_session.new`), complementing the `work()` shell function
5. **Instruction Discovery**: V2 discovers `AGENTS.md` files — the global `~/.config/opencode/AGENTS.md` plus ambient ones from the current directory up to `$HOME` (discovery stops at the project root for projects outside home). This file is the ambient instruction set for the dotfiles repo.

### Permissions Model (V2)

V2 replaced V1's grouped `permission` map with a single ordered `permissions` array. Action names changed: `bash` → `shell`, `task` → `subagent`, `write` and `patch` → `edit`.

```jsonc
{
  "permissions": [
    { "action": "shell", "resource": "git push *", "effect": "ask" },
    { "action": "edit", "resource": "*", "effect": "allow" }
  ]
}
```

> **Security note**: V1 asked before accessing paths outside the project. V2 allows `external_directory` by default. To restore the V1 behavior, add `{ "action": "external_directory", "resource": "*", "effect": "ask" }`.

### Potential Future Integrations

Consider integrating these tools with your AI workflow:

1. **GitHub Copilot CLI**: Could be added to Brewfile and aliased
2. **Cursor Rules**: If using Cursor editor, add configuration files
3. **Continue.dev**: Another AI coding assistant with local models
4. **Windsurf**: VS Code-based AI editor

## Troubleshooting

### OpenCode Issues

- **Command not found**: Ensure Homebrew installation completed: `brew install anomalyco/tap/opencode-v2`
- **Tmux errors**: Verify tmux is running before using `work()` command
- **Git worktree errors**: Check git version and permissions
- **Service issues**: Run `opencode service status`, then `opencode service restart`. Compare with `opencode --standalone` to isolate shared-service problems. Logs live in `~/.local/share/opencode/log/opencode.log` (filter `role=cli` for the client, `role=server` for sessions and tools).
- **API check**: `opencode api get /api/info`

### General AI Agent Tips

1. **Context Window**: Larger context windows work better with more code in view
2. **Temperature**: Lower temperatures (0.1-0.3) for precise code generation
3. **Iterative Refinement**: Break complex tasks into smaller prompts
4. **Code Review**: Always review AI-generated code before committing

## Updates

### Update OpenCode

V2 ships its own upgrade command, which respects the install method:

```bash
opencode upgrade
```

Or via Homebrew, since that is how it is installed here:

```bash
brew update
brew upgrade opencode-v2
```

### Update All Agents

Check for updates to all AI-related tools in Brewfile and update as needed.

## References

- [OpenCode Documentation](https://opencode.ai/docs/)
- [OpenCode CLI](https://opencode.ai/docs/cli)
- [OpenCode TUI](https://opencode.ai/docs/cli/tui)
- [OpenCode Keybinds](https://opencode.ai/docs/cli/keybinds)
- [OpenCode Configuration](https://opencode.ai/docs/config)
- [Migrate from V1](https://opencode.ai/docs/migrate-v1)
- [OpenCode Troubleshooting](https://opencode.ai/docs/troubleshooting)
- [Git Worktree Documentation](https://git-scm.com/docs/git-worktree)
- [Tmux Documentation](https://github.com/tmux/tmux/wiki)
- [zplug Documentation](https://github.com/zplug/zplug)
