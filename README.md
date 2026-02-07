# Neovim Config

Modular Neovim configuration with Java LSP, file explorer, integrated terminal, and git integration. Designed for Neovim 0.11+.

## Requirements

- Neovim >= 0.11
- Git
- Java 21+ (for Java LSP)
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- `ripgrep` (for Telescope live grep) - `brew install ripgrep`

## Installation

```bash
# Clone to nvim config directory
git clone https://github.com/iamvirul/nvim-config.git ~/.config/nvim

# Open Neovim - plugins install automatically on first launch
nvim
```

On first launch:
1. Lazy.nvim will auto-install all plugins
2. Mason will install `jdtls` (Java LSP) and `lua_ls` (Lua LSP)
3. Treesitter parsers will be installed for supported languages

Run `:Mason` to check LSP server status. Run `:Lazy` to check plugin status.

## Plugins

| Plugin | Purpose |
|--------|---------|
| lazy.nvim | Plugin manager |
| catppuccin | Colorscheme |
| telescope.nvim | Fuzzy finder (files, grep, git) |
| neo-tree.nvim | File explorer sidebar |
| nvim-treesitter | Syntax highlighting / parser installer |
| mason.nvim | LSP server installer |
| nvim-jdtls | Java LSP (Eclipse JDTLS) |
| nvim-cmp | Autocompletion |
| LuaSnip | Snippet engine |
| toggleterm.nvim | Integrated terminal |
| gitsigns.nvim | Git gutter signs |
| vim-fugitive | Git commands |
| git-blame.nvim | Inline git blame |

## Keybindings

Leader key: `Space`

### File Explorer (Neo-tree)

| Key | Action |
|-----|--------|
| `<leader>e` | Open file explorer (left sidebar) |
| `<leader>E` | Open file explorer (float) |
| `s` | Open file in horizontal split (in neo-tree) |
| `v` | Open file in vertical split (in neo-tree) |

### Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<leader>ff` / `Ctrl+p` | Find files |
| `<leader>fF` | Find files (current dir) |
| `<leader>fg` / `Ctrl+f` | Live grep |
| `<leader>fG` | Live grep (current dir) |
| `<leader>fs` | Grep string under cursor |
| `<leader>fb` | Open buffers |
| `<leader>fh` | Help tags |
| `<leader>fk` | Keymaps |
| `<leader>f:` | Command history |
| `<leader>fe` | File browser (current dir) |
| `<leader>fE` | File browser (project root) |
| `<leader>fse` | File browser with split support |

### LSP (all languages)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>lf` | Format file |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>ld` | Show diagnostic float |

### Java-specific (in .java files)

| Key | Action |
|-----|--------|
| `<leader>jo` | Organize imports |
| `<leader>jv` | Extract variable |
| `<leader>jc` | Extract constant |
| `<leader>jm` | Extract method (visual mode) |

### Terminal (Toggleterm)

| Key | Action |
|-----|--------|
| `Ctrl+\` | Toggle terminal |
| `<leader>th` | Terminal (horizontal split) |
| `<leader>tv` | Terminal (vertical split) |
| `<leader>tf` | Terminal (floating) |
| `<leader>t1/t2/t3` | Toggle terminal 1/2/3 |
| `Esc` | Exit terminal insert mode |
| `Ctrl+h/j/k/l` | Navigate between terminal and editor splits |

### Window Navigation

| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Move between splits |
| `Ctrl+Up/Down` | Resize height |
| `Ctrl+Left/Right` | Resize width |

### Git

| Key | Action |
|-----|--------|
| `<leader>gs` | Git status |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gP` | Git pull |
| `<leader>gd` | Git diff |
| `<leader>gb` | Git blame |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>tb` | Toggle line blame |
| `]c` / `[c` | Next / previous hunk |

### Autocomplete (nvim-cmp)

| Key | Action |
|-----|--------|
| `Tab` / `Shift+Tab` | Navigate completion items |
| `Enter` | Confirm selection |
| `Ctrl+Space` | Trigger completion |
| `Ctrl+e` | Close completion menu |
| `Ctrl+b` / `Ctrl+f` | Scroll docs |

### Directory / Workspace

| Key | Action |
|-----|--------|
| `<leader>cd` | Change to current file's directory |
| `<leader>cs` | Split + change to file's dir |
| `<leader>cv` | Vsplit + change to file's dir |
| `<leader>pwd` | Print working directory |
| `<leader>nf` | New file |
| `<leader>nd` | New directory |
| `<leader>vc` | Open this nvim config |
| `<leader>ws` | Save workspace layout |
| `<leader>wr` | Restore workspace layout |

## Setup on a New Device

```bash
# 1. Install Neovim 0.11+
brew install neovim    # macOS
# or see https://github.com/neovim/neovim/releases

# 2. Install dependencies
brew install ripgrep

# 3. Install Java (for Java LSP)
brew install openjdk@21

# 4. Install a Nerd Font
brew install --cask font-jetbrains-mono-nerd-font

# 5. Clone config
git clone https://github.com/iamvirul/nvim-config.git ~/.config/nvim

# 6. Launch Neovim (plugins auto-install)
nvim
```

## Structure

```
~/.config/nvim/
  init.lua                     -- Entry point (leader, lazy bootstrap, module loads)
  lazy-lock.json               -- Plugin version lockfile (committed for reproducibility)
  lua/
    config/
      options.lua              -- Basic settings (tabs, numbers, splits, etc.)
      keymaps.lua              -- General keymaps (window nav, directory ops, workspace)
      autocmds.lua             -- Autocommands (DirChanged, filetype settings)
    plugins/
      colorscheme.lua          -- Catppuccin
      telescope.lua            -- Telescope + file-browser + fzf-native + github ext
      neo-tree.lua             -- Neo-tree file explorer
      git.lua                  -- Fugitive + gitsigns + git-blame
      treesitter.lua           -- Treesitter parser installer
      lsp.lua                  -- Mason + mason-lspconfig + native LSP config
      completion.lua           -- nvim-cmp + LuaSnip + sources
      terminal.lua             -- Toggleterm
      java.lua                 -- nvim-jdtls + FileType autocmd for Java
```
