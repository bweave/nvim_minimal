-- Minimal Neovim Configuration
-- Single-file config using mini.nvim as core

--------------------------------------------------------------------------------
-- 1. Bootstrap mini.deps
--------------------------------------------------------------------------------
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing mini.nvim..." | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        'https://github.com/echasnovski/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed mini.nvim" | redraw')
end

-- MiniDeps provides three core functions for plugin management:
--   add(spec)   - Declare a plugin dependency (installs if missing, updates with :DepsUpdate)
--   now(fn)     - Execute fn immediately during startup (for critical UI like colorscheme)
--   later(fn)   - Defer fn execution until after startup (for non-critical plugins)
-- Using later() for most plugins keeps startup fast while now() ensures UI is ready immediately.
require('mini.deps').setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

--------------------------------------------------------------------------------
-- 2. Plugin specifications
--------------------------------------------------------------------------------
now(function()
    add('nvim-treesitter/nvim-treesitter')
end)

later(function()
    add('williamboman/mason.nvim')
end)

-- ESLint (native LSP plugin, handles working directory properly)
later(function()
    add('esmuellert/nvim-eslint')
end)

-- Testing and alternate files
later(function()
    add('vim-test/vim-test')
    add('tpope/vim-projectionist')
    add('tpope/vim-rails')
end)

-- Tmux integration (seamless <C-hjkl> navigation across vim/tmux splits)
now(function()
    add('christoomey/vim-tmux-navigator')
end)

-- LSP progress indicator
later(function()
    add('j-hui/fidget.nvim')
end)

-- Linting (for RuboCop diagnostics)
later(function()
    add('mfussenegger/nvim-lint')
end)

-- Zen mode (distraction-free editing)
later(function()
    add('folke/zen-mode.nvim')
end)

--------------------------------------------------------------------------------
-- 3. Colorscheme (evergreen: everforest-inspired via mini.base16)
--------------------------------------------------------------------------------
local palette = {
    base00 = '#2d353b', -- background
    base01 = '#343f44', -- lighter bg (line numbers, statusline)
    base02 = '#3d484d', -- selection background
    base03 = '#859289', -- comments
    base04 = '#9da9a0', -- dark foreground (status bars)
    base05 = '#d3c6aa', -- foreground
    base06 = '#e6e2cc', -- light foreground
    base07 = '#fdf6e3', -- lightest foreground
    base08 = '#e67e80', -- red (variables, errors)
    base09 = '#e69875', -- orange (constants, numbers)
    base0A = '#dbbc7f', -- yellow (classes, search)
    base0B = '#a7c080', -- green (strings)
    base0C = '#83c092', -- aqua (regex, escape chars)
    base0D = '#7fbbb3', -- blue (functions)
    base0E = '#d699b6', -- purple (keywords)
    base0F = '#d699b6', -- purple (deprecated, embedded)
}

now(function()
    require('mini.base16').setup({ palette = palette })

    local hl = function(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
    end

    -- Transparency overrides
    hl('Normal', { fg = palette.base05, bg = 'NONE' })
    hl('NormalNC', { bg = 'NONE' })
    hl('NormalFloat', { fg = palette.base05, bg = 'NONE' })
    hl('EndOfBuffer', { bg = 'NONE' })
    hl('LineNr', { fg = palette.base03, bg = 'NONE' })
    hl('CursorLineNr', { fg = palette.base05, bg = 'NONE' })
    hl('SignColumn', { bg = 'NONE' })
    hl('CursorLineSign', { bg = 'NONE' })
    hl('CursorLineFold', { bg = 'NONE' })
    hl('FoldColumn', { bg = 'NONE' })
    hl('VertSplit', { fg = palette.base02, bg = 'NONE' })
    hl('WinSeparator', { fg = palette.base02, bg = 'NONE' })

    -- Mini.files floating window transparency
    hl('MiniFilesNormal', { bg = 'NONE' })
    hl('MiniFilesBorder', { bg = 'NONE' })

    -- Statusline (evergreen palette)
    local sl_bg = palette.base00
    hl('MiniStatuslineModeNormal', { fg = palette.base00, bg = palette.base0D, bold = true })
    hl('MiniStatuslineModeInsert', { fg = palette.base00, bg = palette.base0B, bold = true })
    hl('MiniStatuslineModeVisual', { fg = palette.base00, bg = palette.base0E, bold = true })
    hl('MiniStatuslineModeReplace', { fg = palette.base00, bg = palette.base08, bold = true })
    hl('MiniStatuslineModeCommand', { fg = palette.base00, bg = palette.base0A, bold = true })
    hl('MiniStatuslineModeOther', { fg = palette.base00, bg = palette.base0C, bold = true })
    hl('MiniStatuslineFilename', { fg = palette.base05, bg = sl_bg })
    hl('MiniStatuslineDevinfo', { fg = palette.base04, bg = sl_bg })
    hl('MiniStatuslineFileinfo', { fg = palette.base04, bg = sl_bg })
    hl('MiniStatuslineInactive', { fg = palette.base03, bg = sl_bg })
    hl('StatusLine', { fg = palette.base04, bg = sl_bg })
    hl('StatusLineNC', { fg = palette.base03, bg = sl_bg })
end)

--------------------------------------------------------------------------------
-- 4. Editor options
--------------------------------------------------------------------------------
now(function()
    local opt = vim.opt

    -- Line numbers (absolute only)
    opt.number = true
    opt.relativenumber = false
    opt.cursorline = true

    -- Tabs and indentation
    opt.tabstop = 2
    opt.shiftwidth = 2
    opt.softtabstop = 2
    opt.expandtab = true
    opt.smartindent = true

    -- Search
    opt.ignorecase = true
    opt.smartcase = true
    opt.hlsearch = true
    opt.incsearch = true

    -- Appearance
    opt.termguicolors = true
    opt.signcolumn = 'yes'
    opt.scrolloff = 8
    opt.sidescrolloff = 8
    opt.wrap = false
    opt.showmode = false
    opt.laststatus = 3 -- Global statusline

    -- Window title
    opt.title = true
    opt.titlestring = '%{fnamemodify(getcwd(), ":t")}'

    -- Splits
    opt.splitright = true
    opt.splitbelow = true

    -- Clipboard
    opt.clipboard = 'unnamedplus'

    -- Persistent undo, no swap/backup
    opt.undofile = true
    opt.swapfile = false
    opt.backup = false
    opt.writebackup = false

    -- Completion
    opt.completeopt = 'menuone,noinsert,noselect'
    opt.pumheight = 10

    -- Auto-reload files changed outside Neovim
    opt.autoread = true

    -- Misc
    opt.updatetime = 250
    opt.timeoutlen = 300
    opt.mouse = 'a'
    opt.confirm = true
    opt.hidden = true

    -- Session options (for mini.sessions)
    opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'winpos', 'folds', 'globals' }

    -- Global projectionist heuristics (alternates for non-Rails projects)
    vim.g.projectionist_heuristics = {
        -- Ruby with minitest (test/ directory)
        ['test/&Gemfile'] = {
            ['lib/*.rb'] = { alternate = 'test/{}_test.rb' },
            ['test/*_test.rb'] = { alternate = 'lib/{}.rb' },
            ['app/*.rb'] = { alternate = 'test/{}_test.rb' },
            ['test/*/test_*.rb'] = { alternate = 'lib/{dirname}/{basename}.rb' },
        },
        -- Ruby with RSpec (spec/ directory)
        ['spec/&Gemfile'] = {
            ['lib/*.rb'] = { alternate = 'spec/{}_spec.rb' },
            ['spec/*_spec.rb'] = { alternate = 'lib/{}.rb' },
            ['app/*.rb'] = { alternate = 'spec/{}_spec.rb' },
        },
        -- Expo React Native (app.json with app/ directory)
        ['app.json&app/'] = {
            ['app/*.ts'] = { alternate = 'app/__tests__/{}.test.ts' },
            ['app/*.tsx'] = { alternate = 'app/__tests__/{}.test.tsx' },
            ['app/__tests__/*.test.ts'] = { alternate = 'app/{}.ts' },
            ['app/__tests__/*.test.tsx'] = { alternate = 'app/{}.tsx' },
            ['app/*/*.ts'] = { alternate = 'app/__tests__/{dirname}/{basename}.test.ts' },
            ['app/*/*.tsx'] = { alternate = 'app/__tests__/{dirname}/{basename}.test.tsx' },
        },
        -- Rails with React/Vite (app/javascript/src)
        ['app/javascript/src/&Gemfile'] = {
            ['app/javascript/src/*.ts'] = { alternate = 'app/javascript/src/{}.test.ts' },
            ['app/javascript/src/*.tsx'] = { alternate = 'app/javascript/src/{}.test.tsx' },
            ['app/javascript/src/*.test.ts'] = { alternate = 'app/javascript/src/{}.ts' },
            ['app/javascript/src/*.test.tsx'] = { alternate = 'app/javascript/src/{}.tsx' },
        },
        -- Generic JS/TS with Jest (__tests__ directory)
        ['package.json&__tests__/'] = {
            ['src/*.ts'] = { alternate = '__tests__/{}.test.ts' },
            ['src/*.tsx'] = { alternate = '__tests__/{}.test.tsx' },
            ['__tests__/*.test.ts'] = { alternate = 'src/{}.ts' },
            ['__tests__/*.test.tsx'] = { alternate = 'src/{}.tsx' },
        },
        -- Generic JS/TS with co-located tests
        ['package.json'] = {
            ['src/*.ts'] = { alternate = 'src/{}.test.ts' },
            ['src/*.tsx'] = { alternate = 'src/{}.test.tsx' },
            ['src/*.test.ts'] = { alternate = 'src/{}.ts' },
            ['src/*.test.tsx'] = { alternate = 'src/{}.tsx' },
        },
    }
end)

--------------------------------------------------------------------------------
-- 5. Key mappings
--------------------------------------------------------------------------------
now(function()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '

    local map = vim.keymap.set

    -- Window navigation: handled by vim-tmux-navigator (<C-h/j/k/l>)

    -- Window maximize toggle
    local maximized = false
    map('n', '<leader>m', function()
        if maximized then
            vim.cmd('wincmd =')
            maximized = false
        else
            vim.cmd('wincmd _')
            vim.cmd('wincmd |')
            maximized = true
        end
    end, { desc = 'Toggle maximize window' })

    -- Search highlights toggle
    map('n', '<leader>h', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlights' })

    -- Move lines (Alt+j/k, with macOS fallbacks for ∆/˚)
    map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
    map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
    map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
    map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

    -- Better indenting (stay in visual mode)
    map('v', '<', '<gv', { desc = 'Indent left and reselect' })
    map('v', '>', '>gv', { desc = 'Indent right and reselect' })

    -- Buffer navigation
    map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
    map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
    map('n', 'H', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
    map('n', 'L', '<cmd>bnext<cr>', { desc = 'Next buffer' })

    -- Quickfix navigation
    map('n', '[q', '<cmd>cprev<cr>', { desc = 'Previous quickfix' })
    map('n', ']q', '<cmd>cnext<cr>', { desc = 'Next quickfix' })

    -- Testing (vim-test)
    vim.g['test#strategy'] = 'neovim'
    vim.g['test#neovim#start_normal'] = 1 -- Start in normal mode to scroll output
    vim.g['test#javascript#jest#options'] = '--color=always'

    map('n', '<leader>tn', '<cmd>TestNearest<cr>', { desc = 'Test nearest' })
    map('n', '<leader>tf', '<cmd>TestFile<cr>', { desc = 'Test file' })
    map('n', '<leader>ts', '<cmd>TestSuite<cr>', { desc = 'Test suite' })
    map('n', '<leader>tl', '<cmd>TestLast<cr>', { desc = 'Test last' })
    map('n', '<leader>tv', '<cmd>TestVisit<cr>', { desc = 'Visit test file' })

    -- Close test terminal with q (in terminal normal mode)
    vim.api.nvim_create_autocmd('TermOpen', {
        callback = function()
            vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true, silent = true })
            vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = true, silent = true })
        end,
    })
end)

--------------------------------------------------------------------------------
-- 6. Autocommands
--------------------------------------------------------------------------------
now(function()
    local augroup = vim.api.nvim_create_augroup
    local autocmd = vim.api.nvim_create_autocmd

    -- Filetype-specific settings
    autocmd('FileType', {
        group = augroup('filetype_settings', { clear = true }),
        pattern = { 'python', 'lua' },
        callback = function()
            vim.opt_local.tabstop = 4
            vim.opt_local.shiftwidth = 4
            vim.opt_local.softtabstop = 4
        end,
    })

    -- Highlight on yank
    autocmd('TextYankPost', {
        group = augroup('highlight_yank', { clear = true }),
        callback = function()
            vim.highlight.on_yank({ timeout = 200 })
        end,
    })

    -- Return to last edit position
    autocmd('BufReadPost', {
        group = augroup('restore_cursor', { clear = true }),
        callback = function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end,
    })

    -- Auto-resize splits when Vim is resized
    autocmd('VimResized', {
        group = augroup('resize_splits', { clear = true }),
        callback = function()
            vim.cmd('tabdo wincmd =')
        end,
    })

    -- Check for file changes when focusing Neovim or switching buffers
    autocmd({ 'FocusGained', 'BufEnter' }, {
        group = augroup('checktime', { clear = true }),
        callback = function()
            vim.cmd('checktime')
        end,
    })

    -- Clear command line after executing commands
    autocmd('CmdlineLeave', {
        group = augroup('clear_cmdline', { clear = true }),
        callback = function()
            vim.defer_fn(function()
                vim.cmd('echo ""')
            end, 0)
        end,
    })

    -- Close some filetypes with <q>
    autocmd('FileType', {
        group = augroup('close_with_q', { clear = true }),
        pattern = { 'help', 'qf', 'man', 'checkhealth' },
        callback = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
        end,
    })

    -- Markdown list continuation on Enter
    autocmd('FileType', {
        group = augroup('markdown_list_continuation', { clear = true }),
        pattern = { 'markdown' },
        callback = function(event)
            vim.keymap.set('i', '<CR>', function()
                local line = vim.api.nvim_get_current_line()

                -- Check for bullet lists (• is multi-byte, check separately)
                local bullet_patterns = {
                    '^(%s*%-%s)', -- - bullet
                    '^(%s*%*%s)', -- * bullet
                    '^(%s*%+%s)', -- + bullet
                    '^(%s*•%s?)', -- • bullet (may or may not have trailing space)
                }

                for _, pattern in ipairs(bullet_patterns) do
                    local bullet_match = line:match(pattern)
                    if bullet_match then
                        -- Ensure consistent spacing for •
                        if bullet_match:match('•$') then
                            bullet_match = bullet_match .. ' '
                        end
                        -- If line is just the bullet (empty item), remove it and exit list
                        local content_after_bullet = line:sub(#bullet_match + 1)
                        if content_after_bullet:match('^%s*$') then
                            vim.api.nvim_set_current_line('')
                            return '<CR>'
                        end
                        return '<CR>' .. bullet_match
                    end
                end

                -- Check for numbered lists: 1. 2. etc.
                local indent, num = line:match('^(%s*)(%d+)%.%s')
                if indent and num then
                    -- If line is just the number (empty item), remove it and exit list
                    if line:match('^%s*%d+%.%s*$') then
                        vim.api.nvim_set_current_line('')
                        return '<CR>'
                    end
                    local next_num = tonumber(num) + 1
                    return '<CR>' .. indent .. next_num .. '. '
                end

                return '<CR>'
            end, { buffer = event.buf, expr = true, desc = 'Continue list on Enter' })
        end,
    })
end)

--------------------------------------------------------------------------------
-- 7. LSP configuration (Neovim 0.11+ native API)
--------------------------------------------------------------------------------
later(function()
    -- Mason for installing LSP servers (use :Mason to manage)
    require('mason').setup({
        ui = { border = 'rounded' },
    })

    -- LSP keymaps (set on attach)
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_keymaps', { clear = true }),
        callback = function(event)
            local bufnr = event.buf
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            -- ESLint handles JS/TS formatting, not ts_ls
            local is_eslint = client and client.name == 'eslint'
            if is_eslint then
                client.server_capabilities.documentFormattingProvider = true
            elseif client and client.name == 'ts_ls' then
                client.server_capabilities.documentFormattingProvider = false
            end

            map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
            map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
            map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
            map('n', 'gr', vim.lsp.buf.references, 'Go to references')
            map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
            map('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature help')
            map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')
            map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
            map('n', '<leader>D', vim.lsp.buf.type_definition, 'Type definition')
            map('n', '[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
            map('n', ']d', vim.diagnostic.goto_next, 'Next diagnostic')
            map('n', '<leader>d', vim.diagnostic.open_float, 'Line diagnostics')
            map('n', '<leader>cf', function() vim.lsp.buf.format({ async = true }) end, 'Format buffer')

            -- Format on save for supported filetypes (include ESLint which we manually enabled)
            local supports_format = client and (client:supports_method('textDocument/formatting') or is_eslint)
            if supports_format then
                local client_name = client.name
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = vim.api.nvim_create_augroup('LspFormat.' .. bufnr, { clear = true }),
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({
                            bufnr = bufnr,
                            filter = function(c) return c.name == client_name end,
                        })
                    end,
                })
            end
        end,
    })

    -- Default configuration for all LSP servers
    vim.lsp.config('*', {
        root_markers = { '.git' },
    })

    -- Lua LSP
    vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = {
                    library = vim.api.nvim_get_runtime_file('', true),
                    checkThirdParty = false,
                },
                telemetry = { enable = false },
            },
        },
    })

    -- Ruby LSP (install via: gem install ruby-lsp)
    -- Used for non-syntax_tree projects
    vim.lsp.config('ruby_lsp', {
        cmd = { 'ruby-lsp' },
        filetypes = { 'ruby', 'eruby' },
        root_markers = { 'Gemfile', '.git' },
        init_options = {
            formatter = 'rubocop',
            linters = { 'rubocop' },
        },
    })

    -- Syntax Tree LSP (for Planning Center / edna-rails projects)
    -- Only activates when .streerc is present; use with nvim-lint for RuboCop diagnostics
    vim.lsp.config('syntax_tree', {
        cmd = { 'bundle', 'exec', 'stree', 'lsp' },
        filetypes = { 'ruby' },
        root_markers = { '.streerc' },
    })

    -- TypeScript/JavaScript
    vim.lsp.config('ts_ls', {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
    })

    -- Enable servers (they will start when matching filetypes are opened)
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('ruby_lsp')
    vim.lsp.enable('syntax_tree')
    vim.lsp.enable('ts_ls')

    -- ESLint (using nvim-eslint plugin for proper native LSP support)
    require('nvim-eslint').setup({
        settings = {
            format = true,
        },
    })

    -- Diagnostic appearance
    vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = '●' },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            border = 'rounded',
            source = true,
        },
    })

    -- Diagnostic signs
    local signs = { Error = '✘', Warn = '▲', Hint = '⚑', Info = '●' }
    for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end

    -- LSP progress indicator (shows ruby_lsp indexing, etc.)
    require('fidget').setup({
        notification = {
            window = {
                winblend = 0, -- Transparency for terminal background
            },
        },
    })
end)

--------------------------------------------------------------------------------
-- 8. Linting (nvim-lint for RuboCop diagnostics)
--------------------------------------------------------------------------------
later(function()
    local lint = require('lint')

    -- Configure linters by filetype
    lint.linters_by_ft = {
        ruby = { 'rubocop' },
    }

    -- Use bundler for RuboCop in projects with Gemfile
    lint.linters.rubocop.cmd = 'bundle'
    lint.linters.rubocop.args = vim.list_extend(
        { 'exec', 'rubocop' },
        lint.linters.rubocop.args
    )

    -- Run linter on save and when entering a buffer
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost' }, {
        group = vim.api.nvim_create_augroup('nvim_lint', { clear = true }),
        callback = function()
            lint.try_lint()
        end,
    })
end)

--------------------------------------------------------------------------------
-- 9. Treesitter configuration (nvim-treesitter 1.0+ API)
--------------------------------------------------------------------------------
later(function()
    -- Parsers to install (run :TSInstall <parser> or :TSUpdate)
    local parsers = {
        'lua', 'vim', 'vimdoc', 'query',
        'javascript', 'typescript', 'tsx',
        'python', 'ruby',
        'html', 'css', 'json', 'yaml', 'toml',
        'bash', 'markdown', 'markdown_inline',
    }

    -- Auto-install missing parsers when entering a buffer
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_install', { clear = true }),
        callback = function()
            local ft = vim.bo.filetype
            local lang = vim.treesitter.language.get_lang(ft) or ft
            if vim.tbl_contains(parsers, lang) then
                pcall(function()
                    if not pcall(vim.treesitter.language.inspect, lang) then
                        vim.cmd('TSInstall ' .. lang)
                    end
                end)
            end
        end,
    })

    -- Enable treesitter highlighting for supported filetypes
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_highlight', { clear = true }),
        callback = function()
            pcall(vim.treesitter.start)
        end,
    })
end)

--------------------------------------------------------------------------------
-- 10. Mini.nvim modules
--------------------------------------------------------------------------------
-- Icons (load first)
now(function()
    require('mini.icons').setup()
end)

-- Tabline (buffer list at top)
now(function()
    require('mini.tabline').setup({
        show_icons = true,
        tabpage_section = 'right',
    })

    -- Style tabline to match evergreen palette
    vim.api.nvim_set_hl(0, 'MiniTablineCurrent', { fg = palette.base05, bg = palette.base02, bold = true })
    vim.api.nvim_set_hl(0, 'MiniTablineVisible', { fg = palette.base04, bg = palette.base01 })
    vim.api.nvim_set_hl(0, 'MiniTablineHidden', { fg = palette.base03, bg = palette.base00 })
    vim.api.nvim_set_hl(0, 'MiniTablineModifiedCurrent', { fg = palette.base0A, bg = palette.base02, bold = true })
    vim.api.nvim_set_hl(0, 'MiniTablineModifiedVisible', { fg = palette.base0A, bg = palette.base01 })
    vim.api.nvim_set_hl(0, 'MiniTablineModifiedHidden', { fg = palette.base09, bg = palette.base00 })
    vim.api.nvim_set_hl(0, 'MiniTablineFill', { bg = palette.base00 })
    vim.api.nvim_set_hl(0, 'MiniTablineTabpagesection', { fg = palette.base00, bg = palette.base0D, bold = true })
end)

-- Statusline (matches tmux powerline style)
now(function()
    local statusline = require('mini.statusline')
    statusline.setup({
        use_icons = true,
        content = {
            active = function()
                local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
                local filename = statusline.section_filename({ trunc_width = 140 })
                local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })

                mode = vim.trim(mode)
                fileinfo = vim.trim(fileinfo)

                local sep_r = '\u{e0b0}'
                local sep_l = '\u{e0b2}'

                -- Get mode bg color
                local mode_bg = palette.base0D
                if mode_hl == 'MiniStatuslineModeInsert' then
                    mode_bg = palette.base0B
                elseif mode_hl == 'MiniStatuslineModeVisual' then
                    mode_bg = palette.base0E
                elseif mode_hl == 'MiniStatuslineModeReplace' then
                    mode_bg = palette.base08
                elseif mode_hl == 'MiniStatuslineModeCommand' then
                    mode_bg = palette.base0A
                elseif mode_hl == 'MiniStatuslineModeOther' then
                    mode_bg = palette.base0C
                end

                vim.api.nvim_set_hl(0, 'StlSepR', { fg = mode_bg, bg = palette.base00 })
                vim.api.nvim_set_hl(0, 'StlSepL', { fg = mode_bg, bg = palette.base00 })

                -- Build statusline manually to avoid combine_groups spacing
                return table.concat({
                    '%#', mode_hl, '# ', mode, ' ',
                    '%#StlSepR#', sep_r,
                    '%<',
                    '%#MiniStatuslineFilename# ', filename,
                    '%=',
                    '%#MiniStatuslineFileinfo#', fileinfo, ' ',
                    '%#StlSepL#', sep_l,
                    '%#', mode_hl, '# %l:%c ',
                })
            end,
        },
    })
end)

-- Key clues (which-key style hints for key sequences)
later(function()
    local clue = require('mini.clue')
    clue.setup({
        triggers = {
            -- Leader triggers
            { mode = 'n', keys = '<Leader>' },
            { mode = 'x', keys = '<Leader>' },

            -- Built-in completion
            { mode = 'i', keys = '<C-x>' },

            -- `g` key
            { mode = 'n', keys = 'g' },
            { mode = 'x', keys = 'g' },

            -- Marks
            { mode = 'n', keys = "'" },
            { mode = 'n', keys = '`' },
            { mode = 'x', keys = "'" },
            { mode = 'x', keys = '`' },

            -- Registers
            { mode = 'n', keys = '"' },
            { mode = 'x', keys = '"' },
            { mode = 'i', keys = '<C-r>' },
            { mode = 'c', keys = '<C-r>' },

            -- Window commands
            { mode = 'n', keys = '<C-w>' },

            -- `z` key
            { mode = 'n', keys = 'z' },
            { mode = 'x', keys = 'z' },

            -- Brackets
            { mode = 'n', keys = '[' },
            { mode = 'n', keys = ']' },
        },
        clues = {
            -- Leader group descriptions
            { mode = 'n', keys = '<Leader>b', desc = '+buffers' },
            { mode = 'n', keys = '<Leader>c', desc = '+code' },
            { mode = 'n', keys = '<Leader>f', desc = '+find' },
            { mode = 'n', keys = '<Leader>g', desc = '+git' },
            { mode = 'n', keys = '<Leader>gh', desc = '+hunks' },
            { mode = 'n', keys = '<Leader>t', desc = '+test' },
            { mode = 'n', keys = '<Leader>y', desc = '+yank' },
            { mode = 'x', keys = '<Leader>g', desc = '+git' },
            { mode = 'x', keys = '<Leader>y', desc = '+yank' },

            -- Built-in clue generators
            clue.gen_clues.builtin_completion(),
            clue.gen_clues.g(),
            clue.gen_clues.marks(),
            clue.gen_clues.registers(),
            clue.gen_clues.windows(),
            clue.gen_clues.z(),
        },
        window = {
            delay = 300,
            config = {
                width = 'auto',
            },
        },
    })
end)

-- File explorer
later(function()
    require('mini.files').setup({
        mappings = {
            close = 'q',
            go_in = 'l',
            go_in_plus = '<CR>',
            go_out = 'h',
            go_out_plus = 'H',
            reset = '<BS>',
            reveal_cwd = '@',
            show_help = 'g?',
            synchronize = '=',
            trim_left = '<',
            trim_right = '>',
        },
    })

    vim.keymap.set('n', '<leader>e', function()
        if not MiniFiles.close() then
            MiniFiles.open()
        end
    end, { desc = 'Toggle file explorer' })

    vim.keymap.set('n', '<leader>F', function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
    end, { desc = 'Reveal current file in explorer' })
end)

-- Fuzzy finder (pick + extra pickers)
later(function()
    require('mini.pick').setup()
    require('mini.extra').setup()

    local map = vim.keymap.set

    -- Git-aware file finder
    map('n', '<C-P>', function()
        local is_git = vim.fn.isdirectory('.git') == 1 or
            vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null'):match('true')
        if is_git then
            MiniPick.builtin.files({ tool = 'git' })
        else
            MiniPick.builtin.files()
        end
    end, { desc = 'Find files (git-aware)' })

    map('n', '<leader>ff', function()
        MiniPick.builtin.files()
    end, { desc = 'Find files' })

    map('n', '<leader>fg', function()
        MiniPick.builtin.grep_live()
    end, { desc = 'Live grep' })

    map('n', '<leader>bb', function()
        MiniPick.builtin.buffers()
    end, { desc = 'Find buffers' })

    map('n', '<leader>C', function()
        MiniPick.builtin.cli({ command = { 'find', vim.fn.stdpath('data') .. '/site/pack', '-name', '*.vim', '-path', '*/colors/*' } })
    end, { desc = 'Colorscheme picker' })

    map('n', '<leader>?', function()
        MiniExtra.pickers.keymaps()
    end, { desc = 'Search keymaps' })
end)

-- Git signs in the gutter
later(function()
    local diff = require('mini.diff')
    diff.setup({
        view = {
            style = 'sign',
            signs = { add = '│', change = '│', delete = '_' },
        },
        source = diff.gen_source.git(),
    })

    -- Hunk navigation
    vim.keymap.set('n', '<leader>ghn', function() diff.goto_hunk('next') end, { desc = 'Git hunk next' })
    vim.keymap.set('n', '<leader>ghp', function() diff.goto_hunk('prev') end, { desc = 'Git hunk prev' })
    vim.keymap.set('n', '<leader>gd', function() diff.toggle_overlay() end, { desc = 'Toggle git diff overlay' })

    -- Lazygit in floating terminal
    vim.keymap.set('n', '<leader>gg', function()
        local width = math.floor(vim.o.columns * 0.9)
        local height = math.floor(vim.o.lines * 0.9)
        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_open_win(buf, true, {
            relative = 'editor',
            width = width,
            height = height,
            col = math.floor((vim.o.columns - width) / 2),
            row = math.floor((vim.o.lines - height) / 2),
            style = 'minimal',
            border = 'rounded',
        })
        vim.wo[win].winhighlight = 'Normal:Normal'
        vim.fn.termopen('lazygit', {
            on_exit = function()
                if vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_close(win, true)
                end
            end,
        })
        vim.cmd('startinsert')
    end, { desc = 'Open lazygit' })
end)

-- Completion
later(function()
    require('mini.completion').setup({
        lsp_completion = {
            source_func = 'omnifunc',
            auto_setup = true,
        },
    })
end)

-- Auto pairs
later(function()
    require('mini.pairs').setup()
end)

-- Surround
later(function()
    require('mini.surround').setup()
end)

-- Split/join
later(function()
    require('mini.splitjoin').setup()

    vim.keymap.set('n', '<leader>j', function()
        MiniSplitjoin.toggle()
    end, { desc = 'Split/join lines' })

    vim.keymap.set('n', '<leader>k', function()
        MiniSplitjoin.toggle()
    end, { desc = 'Split/join lines' })
end)

-- Sessions (auto-save and restore per directory)
later(function()
    local session_dir = vim.fn.expand('~/.local/share/nvim/sessions')

    -- Convert cwd to a session name (e.g., /Users/foo/project -> __Users__foo__project)
    local function get_session_name()
        return (vim.fn.getcwd():gsub('/', '__'):gsub(':', ''))
    end

    require('mini.sessions').setup({
        autoread = false,
        autowrite = false,
        directory = session_dir,
        file = '',
    })

    -- Auto-read global session for current directory on startup (only if no file args)
    local session_name = get_session_name()
    local session_path = session_dir .. '/' .. session_name
    if vim.fn.filereadable(session_path) == 1 and vim.fn.argc() == 0 then
        vim.defer_fn(function()
            MiniSessions.read(session_name)
        end, 0)
    end

    -- Save session on exit
    vim.api.nvim_create_autocmd('VimLeavePre', {
        group = vim.api.nvim_create_augroup('MiniSessionsAutoSave', { clear = true }),
        callback = function()
            local bufs = vim.tbl_filter(function(b)
                return vim.bo[b].buflisted and vim.api.nvim_buf_get_name(b) ~= ''
            end, vim.api.nvim_list_bufs())
            if #bufs > 0 then
                MiniSessions.write(get_session_name())
            end
        end,
    })
end)

--------------------------------------------------------------------------------
-- 11. Zen mode (distraction-free editing)
--------------------------------------------------------------------------------
later(function()
    require('zen-mode').setup({
        window = {
            width = 120,
            options = {
                number = false,
                relativenumber = false,
                signcolumn = 'no',
                cursorline = false,
            },
        },
        plugins = {
            options = {
                laststatus = 0,
            },
            tmux = { enabled = true },
        },
    })

    vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<cr>', { desc = 'Toggle zen mode' })
end)

--------------------------------------------------------------------------------
-- 12. Copy for Slack (markdown → HTML clipboard via md2slack)
--------------------------------------------------------------------------------
later(function()
    local md2slack = vim.fn.stdpath('config') .. '/bin/md2slack'

    local function copy_for_slack(lines)
        local result = vim.fn.system(md2slack, lines)
        if vim.v.shell_error ~= 0 then
            vim.notify('Failed to copy for Slack: ' .. result, vim.log.levels.ERROR)
            return false
        end
        return true
    end

    vim.keymap.set('n', '<leader>yS', function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        if copy_for_slack(lines) then
            vim.notify('Copied buffer for Slack', vim.log.levels.INFO)
        end
    end, { desc = 'Copy buffer for Slack' })

    vim.keymap.set('v', '<leader>yS', function()
        vim.cmd('normal! ' .. vim.api.nvim_replace_termcodes('<Esc>', true, false, true))
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")
        local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
        if copy_for_slack(lines) then
            vim.notify('Copied selection for Slack', vim.log.levels.INFO)
        end
    end, { desc = 'Copy selection for Slack' })
end)

--------------------------------------------------------------------------------
-- 13. Berg Weekly Update (~/brain only)
--------------------------------------------------------------------------------
later(function()
    local function berg_weekly_update()
        -- Only works from ~/brain directory
        local cwd = vim.fn.getcwd()
        local brain_dir = vim.fn.expand('~/brain')
        if not cwd:find(brain_dir, 1, true) then
            vim.notify('Berg Weekly Update only works from ~/brain', vim.log.levels.WARN)
            return
        end

        local date_str = os.date('%m-%d-%Y')
        local dir_path = vim.fn.expand('~/brain/berg-weekly-updates')
        local file_path = dir_path .. '/' .. date_str .. '.md'

        -- Create directory if needed
        vim.fn.mkdir(dir_path, 'p')

        -- Check if file already exists
        if vim.fn.filereadable(file_path) == 1 then
            vim.cmd('edit ' .. vim.fn.fnameescape(file_path))
            vim.notify('Opened existing update: ' .. date_str, vim.log.levels.INFO)
            return
        end

        -- Template content (uses • for Slack-compatible bullets)
        local template = {
            '**Weekly Update** ' .. os.date('%m-%d-%y'),
            '',
            '**Wins**',
            '',
            '- ',
            '',
            '**Risks**',
            '',
            '- ',
            '',
            '**Priorities**',
            '',
            '- ',
            '',
        }

        -- Create and populate the file
        vim.cmd('edit ' .. vim.fn.fnameescape(file_path))
        vim.api.nvim_buf_set_lines(0, 0, -1, false, template)

        -- Position cursor at end of first bullet and enter insert mode
        vim.api.nvim_win_set_cursor(0, { 5, 2 })
        vim.cmd('startinsert!')

        vim.notify('Created weekly update: ' .. date_str, vim.log.levels.INFO)
    end

    vim.keymap.set('n', '<leader>U', berg_weekly_update, { desc = 'Berg Weekly Update' })
end)

--------------------------------------------------------------------------------
-- 14. Open on GitHub
--------------------------------------------------------------------------------
later(function()
    local function get_github_url(start_line, end_line)
        -- Get git root
        local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
        if vim.v.shell_error ~= 0 then
            return nil, 'Not a git repository'
        end

        -- Get remote URL
        local remote = vim.fn.systemlist('git remote get-url origin')[1]
        if vim.v.shell_error ~= 0 then
            return nil, 'No origin remote found'
        end

        -- Convert SSH/git URL to HTTPS
        -- git@github.com:user/repo.git -> https://github.com/user/repo
        -- https://github.com/user/repo.git -> https://github.com/user/repo
        local github_url = remote
            :gsub('git@github.com:', 'https://github.com/')
            :gsub('%.git$', '')

        -- Get current branch
        local branch = vim.fn.systemlist('git rev-parse --abbrev-ref HEAD')[1]
        if vim.v.shell_error ~= 0 then
            branch = 'main'
        end

        -- Get file path relative to git root
        local file_path = vim.fn.expand('%:p')
        local relative_path = file_path:sub(#git_root + 2)

        -- Build URL with line number(s)
        local url = string.format('%s/blob/%s/%s#L%d', github_url, branch, relative_path, start_line)
        if end_line and end_line ~= start_line then
            url = url .. '-L' .. end_line
        end

        return url
    end

    local function open_on_github(start_line, end_line)
        local url, err = get_github_url(start_line, end_line)
        if not url then
            vim.notify(err, vim.log.levels.ERROR)
            return
        end

        vim.fn.system({ 'open', url })
        vim.notify('Opened on GitHub', vim.log.levels.INFO)
    end

    -- Normal mode: open current line
    vim.keymap.set('n', '<leader>gb', function()
        open_on_github(vim.fn.line('.'))
    end, { desc = 'Browse line on GitHub' })

    -- Visual mode: open selected lines
    vim.keymap.set('v', '<leader>gb', function()
        vim.cmd('normal! ' .. vim.api.nvim_replace_termcodes('<Esc>', true, false, true))
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")
        open_on_github(start_line, end_line)
    end, { desc = 'Browse lines on GitHub' })
end)
