# nvim_minimal

A minimal, single-file Neovim configuration using [mini.nvim](https://github.com/echasnovski/mini.nvim) as the core framework. Targets Neovim 0.11+ with native LSP.

## Installation

```bash
git clone https://github.com/bweave/nvim_minimal ~/.config/nvim_minimal
NVIM_APPNAME=nvim_minimal nvim
```

On first launch, mini.nvim auto-installs. Other plugins install as needed via mini.deps.

## What's Included

- **Single `init.lua`** organized into numbered sections
- **Everforest-inspired colorscheme** via mini.base16 with transparency
- **Native LSP** for Lua, Ruby, TypeScript/JavaScript, and ESLint
- **Treesitter** highlighting with auto-installed parsers
- **Fuzzy finder** (`<C-p>` for files, `<leader>fg` for grep, `<leader>bb` for buffers)
- **File explorer** via mini.files (`<leader>e`)
- **Git** signs in gutter, hunk navigation, lazygit integration (`<leader>gg`)
- **Testing** via vim-test (`<leader>t` prefix)
- **Tmux integration** with `<C-hjkl>` for seamless split navigation
- **Sessions** auto-saved and restored per directory
- **Zen mode** for distraction-free editing (`<leader>z`)
- **Copy for Slack** converts markdown to Slack-formatted clipboard (`<leader>yS`)

Press `<Space>` and wait for [mini.clue](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-clue.md) to show all available keybindings.

## LSP Servers

Install servers via Mason (`:Mason`) or your system package manager.

| Language | Server | Notes |
|----------|--------|-------|
| Lua | lua_ls | Neovim runtime included in workspace |
| Ruby | ruby_lsp | Default for Ruby projects |
| Ruby | syntax_tree | Activates when `.streerc` present |
| TypeScript/JS | ts_ls + eslint | ESLint handles formatting |

## Plugins

Managed via [mini.deps](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md). Run `:DepsUpdate` to update all.

| Plugin | Purpose |
|--------|---------|
| mini.nvim | Core framework (icons, tabline, statusline, files, pick, diff, completion, pairs, surround, splitjoin, sessions, clue) |
| nvim-treesitter | Syntax highlighting |
| mason.nvim | LSP server installer |
| nvim-eslint | ESLint LSP integration |
| vim-test | Test runner |
| vim-projectionist | Alternate file navigation |
| vim-rails | Rails-specific support |
| vim-tmux-navigator | Seamless vim/tmux split navigation |
| fidget.nvim | LSP progress indicator |
| nvim-lint | Linting (RuboCop) |
| zen-mode.nvim | Distraction-free editing |

## License

MIT
