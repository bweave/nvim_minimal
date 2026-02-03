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
-- 3. Colorscheme (habamax with transparency)
--------------------------------------------------------------------------------
now(function()
    vim.cmd.colorscheme('habamax')

    local hl = function(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
    end

    -- Transparency overrides
    hl('Normal', { bg = 'NONE' })
    hl('NormalNC', { bg = 'NONE' })
    hl('EndOfBuffer', { bg = 'NONE' })
    hl('SignColumn', { bg = 'NONE' })
    hl('FoldColumn', { bg = 'NONE' })
    hl('VertSplit', { bg = 'NONE' })
    hl('WinSeparator', { bg = 'NONE' })

    -- Statusline (habamax palette)
    local sl_bg = '#1c1c1c'
    hl('MiniStatuslineModeNormal', { fg = '#1c1c1c', bg = '#5f87af', bold = true })
    hl('MiniStatuslineModeInsert', { fg = '#1c1c1c', bg = '#5faf5f', bold = true })
    hl('MiniStatuslineModeVisual', { fg = '#1c1c1c', bg = '#af87af', bold = true })
    hl('MiniStatuslineModeReplace', { fg = '#1c1c1c', bg = '#af5f5f', bold = true })
    hl('MiniStatuslineModeCommand', { fg = '#1c1c1c', bg = '#af875f', bold = true })
    hl('MiniStatuslineModeOther', { fg = '#1c1c1c', bg = '#5f8787', bold = true })
    hl('MiniStatuslineFilename', { fg = '#bcbcbc', bg = sl_bg })
    hl('MiniStatuslineDevinfo', { fg = '#9e9e9e', bg = sl_bg })
    hl('MiniStatuslineFileinfo', { fg = '#9e9e9e', bg = sl_bg })
    hl('MiniStatuslineInactive', { fg = '#767676', bg = sl_bg })
    hl('StatusLine', { fg = '#9e9e9e', bg = sl_bg })
    hl('StatusLineNC', { fg = '#767676', bg = sl_bg })
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

    -- Misc
    opt.updatetime = 250
    opt.timeoutlen = 300
    opt.mouse = 'a'
    opt.confirm = true
    opt.hidden = true

    -- Session options (for mini.sessions)
    opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'winpos', 'folds', 'globals' }

    -- vim-matchup: enable on-screen matching, disable offscreen statusline display
    vim.g.matchup_matchparen_offscreen = {}
    -- Disable treesitter integration to avoid compatibility errors with newer neovim
    vim.g.matchup_treesitter_enabled = 0

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

    -- Move lines
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

    -- Python (pyright)
    vim.lsp.config('pyright', {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
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
    vim.lsp.enable('pyright')
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

    -- Style tabline to match habamax
    vim.api.nvim_set_hl(0, 'MiniTablineCurrent', { fg = '#bcbcbc', bg = '#303030', bold = true })
    vim.api.nvim_set_hl(0, 'MiniTablineVisible', { fg = '#9e9e9e', bg = '#262626' })
    vim.api.nvim_set_hl(0, 'MiniTablineHidden', { fg = '#767676', bg = '#1c1c1c' })
    vim.api.nvim_set_hl(0, 'MiniTablineModifiedCurrent', { fg = '#d7af87', bg = '#303030', bold = true })
    vim.api.nvim_set_hl(0, 'MiniTablineModifiedVisible', { fg = '#d7af87', bg = '#262626' })
    vim.api.nvim_set_hl(0, 'MiniTablineModifiedHidden', { fg = '#af875f', bg = '#1c1c1c' })
    vim.api.nvim_set_hl(0, 'MiniTablineFill', { bg = '#1c1c1c' })
    vim.api.nvim_set_hl(0, 'MiniTablineTabpagesection', { fg = '#1c1c1c', bg = '#5f87af', bold = true })
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
                local mode_bg = '#5f87af'
                if mode_hl == 'MiniStatuslineModeInsert' then
                    mode_bg = '#5faf5f'
                elseif mode_hl == 'MiniStatuslineModeVisual' then
                    mode_bg = '#af87af'
                elseif mode_hl == 'MiniStatuslineModeReplace' then
                    mode_bg = '#af5f5f'
                elseif mode_hl == 'MiniStatuslineModeCommand' then
                    mode_bg = '#af875f'
                elseif mode_hl == 'MiniStatuslineModeOther' then
                    mode_bg = '#5f8787'
                end

                vim.api.nvim_set_hl(0, 'StlSepR', { fg = mode_bg, bg = '#1c1c1c' })
                vim.api.nvim_set_hl(0, 'StlSepL', { fg = mode_bg, bg = '#1c1c1c' })

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

-- Git signs
later(function()
    require('mini.diff').setup({
        view = {
            style = 'sign',
            signs = { add = '│', change = '│', delete = '_' },
        },
    })
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

