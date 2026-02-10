# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a minimal, single-file Neovim configuration (`init.lua`) using mini.nvim as the core plugin framework. It targets Neovim 0.11+ and uses the native LSP API.

## Architecture

The configuration is organized into numbered sections in `init.lua`:

1. **Bootstrap** - Auto-installs mini.deps (plugin manager)
2. **Plugin specs** - Uses `now()` for immediate and `later()` for deferred loading
3. **Colorscheme** - Everforest-inspired via mini.base16 with transparency overrides
4. **Editor options** - Standard Neovim settings
5. **Key mappings** - Leader is space, includes vim-test bindings
6. **Autocommands** - Filetype settings, yank highlight, cursor restore, markdown list continuation
7. **LSP** - Native Neovim 0.11+ API (`vim.lsp.config`, `vim.lsp.enable`)
8. **Linting** - nvim-lint for RuboCop diagnostics
9. **Treesitter** - Auto-installs parsers, enables highlighting
10. **Mini modules** - Icons, tabline, statusline, clue (which-key style hints), files, pick, diff (with git signs and hunk navigation), completion, pairs, surround, splitjoin, sessions
11. **Zen mode** - Distraction-free editing with `<leader>z`
12. **Copy for Slack** - `<leader>yS` copies buffer/selection as Slack-compatible HTML
13. **Berg Weekly Update** - `<leader>U` creates weekly update file (only in ~/brain)
14. **Open on GitHub** - `<leader>gb` opens current line/selection on GitHub

## Key Patterns

**Plugin loading**: Uses mini.deps with `now()` for critical plugins (colorscheme, options, keymaps) and `later()` for everything else.

**LSP servers configured**:
- `lua_ls` - Lua
- `ruby_lsp` - Ruby (default)
- `syntax_tree` - Ruby (activates when `.streerc` present)
- `ts_ls` - TypeScript/JavaScript
- `eslint` - via nvim-eslint plugin

**Alternate file mappings**: Defined in `vim.g.projectionist_heuristics` for Ruby (minitest/RSpec), Expo React Native, Rails with Vite, and generic JS/TS projects.

## External Scripts

**bin/md2slack** - Converts markdown to Slack-compatible HTML clipboard. Uses pandoc for markdown parsing and AppleScript to set the macOS clipboard's `text/html` buffer. Requires `pandoc`.

## Testing This Config

```bash
NVIM_APPNAME=nvim_minimal nvim
```

## Lua Diagnostics Note

The `undefined-global 'vim'` warnings from Lua language server are expected - `vim` is a global provided by Neovim at runtime. The LSP config includes `diagnostics = { globals = { 'vim' } }` to suppress these when lua_ls is active.
