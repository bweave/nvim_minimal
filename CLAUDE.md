# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a minimal, single-file Neovim configuration (`init.lua`) using mini.nvim as the core plugin framework. It targets Neovim 0.11+ and uses the native LSP API.

## Architecture

The configuration is organized into numbered sections in `init.lua`:

1. **Bootstrap** - Auto-installs mini.deps (plugin manager)
2. **Plugin specs** - Uses `now()` for immediate and `later()` for deferred loading
3. **Colorscheme** - habamax with transparency overrides
4. **Editor options** - Standard Neovim settings
5. **Key mappings** - Leader is space, includes vim-test bindings
6. **Autocommands** - Filetype settings, yank highlight, cursor restore
7. **LSP** - Native Neovim 0.11+ API (`vim.lsp.config`, `vim.lsp.enable`)
8. **Linting** - nvim-lint for RuboCop diagnostics
9. **Treesitter** - Auto-installs parsers, enables highlighting
10. **Mini modules** - Icons, tabline, statusline, files, pick, diff, completion, pairs, surround, splitjoin, sessions

## Key Patterns

**Plugin loading**: Uses mini.deps with `now()` for critical plugins (colorscheme, options, keymaps) and `later()` for everything else.

**LSP servers configured**:
- `lua_ls` - Lua
- `pyright` - Python
- `ruby_lsp` - Ruby (default)
- `syntax_tree` - Ruby (activates when `.streerc` present)
- `ts_ls` - TypeScript/JavaScript
- `eslint` - via nvim-eslint plugin

**Alternate file mappings**: Defined in `vim.g.projectionist_heuristics` for Ruby (minitest/RSpec), Expo React Native, Rails with Vite, and generic JS/TS projects.

## Testing This Config

```bash
# Test with isolated config (doesn't affect your real config)
NVIM_APPNAME=nvim_minimal nvim

# Or symlink to ~/.config/nvim_minimal and run
nvim --cmd "set rtp^=."
```

## Lua Diagnostics Note

The `undefined-global 'vim'` warnings from Lua language server are expected - `vim` is a global provided by Neovim at runtime. The LSP config includes `diagnostics = { globals = { 'vim' } }` to suppress these when lua_ls is active.
