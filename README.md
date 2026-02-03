# nvim_minimal

A minimal, single-file Neovim configuration using [mini.nvim](https://github.com/echasnovski/mini.nvim) as the core framework. Targets Neovim 0.11+ and uses the native LSP API.

## Installation

```bash
# Clone to your config directory
git clone https://github.com/yourusername/nvim_minimal ~/.config/nvim_minimal

# Run with isolated config (doesn't affect your existing setup)
NVIM_APPNAME=nvim_minimal nvim
```

On first launch, mini.nvim will auto-install. Other plugins will install as needed via mini.deps.

## Features

- Single `init.lua` file (~800 lines)
- Fast startup with deferred plugin loading
- Native Neovim 0.11+ LSP configuration
- Seamless tmux/vim split navigation
- LSP progress indicator for indexing feedback
- Auto-save/restore sessions per directory
- habamax colorscheme with transparency support

## LSP Servers

| Language | Server | Notes |
|----------|--------|-------|
| Lua | lua_ls | Neovim runtime included in workspace |
| Python | pyright | |
| Ruby | ruby_lsp | Default for Ruby projects |
| Ruby | syntax_tree | Activates when `.streerc` present |
| TypeScript/JavaScript | ts_ls | |
| JavaScript | eslint | Via nvim-eslint plugin, handles formatting |

Install servers via Mason (`:Mason`) or your system package manager.

## Key Bindings

Leader key is `<Space>`.

### Navigation

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move between vim/tmux splits |
| `H` / `L` | Previous/next buffer |
| `[b` / `]b` | Previous/next buffer |
| `[q` / `]q` | Previous/next quickfix |
| `[d` / `]d` | Previous/next diagnostic |

### Files & Search

| Key | Action |
|-----|--------|
| `<C-p>` | Find files (git-aware) |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>bb` | Find buffers |
| `<leader>e` | Toggle file explorer |
| `<leader>F` | Reveal current file in explorer |
| `<leader>?` | Search keymaps |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>D` | Type definition |
| `<leader>d` | Line diagnostics |
| `<leader>cf` | Format buffer |

### Testing (vim-test)

| Key | Action |
|-----|--------|
| `<leader>tn` | Test nearest |
| `<leader>tf` | Test file |
| `<leader>ts` | Test suite |
| `<leader>tl` | Test last |
| `<leader>tv` | Visit test file |

### Editing

| Key | Action |
|-----|--------|
| `<A-j>` / `<A-k>` | Move line(s) up/down |
| `<` / `>` (visual) | Indent and reselect |
| `<leader>j` | Split/join lines |
| `<leader>m` | Toggle maximize window |
| `<leader>h` | Clear search highlights |
| `<leader>sv` | Split vertical |
| `<leader>sh` | Split horizontal |

### Mini.surround

| Key | Action |
|-----|--------|
| `sa` | Add surrounding |
| `sd` | Delete surrounding |
| `sr` | Replace surrounding |
| `sf` | Find surrounding |
| `sh` | Highlight surrounding |

## Plugins

Managed via [mini.deps](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md):

| Plugin | Purpose |
|--------|---------|
| mini.nvim | Core framework (icons, tabline, statusline, files, pick, diff, completion, pairs, surround, splitjoin, sessions) |
| nvim-treesitter | Syntax highlighting |
| mason.nvim | LSP server installer |
| nvim-eslint | ESLint LSP integration |
| vim-test | Test runner |
| vim-projectionist | Alternate file navigation |
| vim-rails | Rails-specific support |
| vim-tmux-navigator | Seamless vim/tmux navigation |
| fidget.nvim | LSP progress indicator |
| nvim-lint | Linting (RuboCop) |

## Tmux Integration

For `<C-h/j/k/l>` to work across tmux splits, add to your `~/.tmux.conf`:

```tmux
# Smart pane switching with awareness of Vim splits
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"
bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
bind-key -T copy-mode-vi 'C-\' select-pane -l
```

## Customization

The configuration is organized into numbered sections in `init.lua`:

1. Bootstrap - Auto-installs mini.deps
2. Plugin specs - `now()` for immediate, `later()` for deferred loading
3. Colorscheme - habamax with transparency overrides
4. Editor options - Standard Neovim settings
5. Key mappings - Leader is space
6. Autocommands - Filetype settings, yank highlight, cursor restore
7. LSP - Native Neovim 0.11+ API
8. Linting - nvim-lint for RuboCop
9. Treesitter - Auto-installs parsers
10. Mini modules - All mini.nvim configurations

## License

MIT
