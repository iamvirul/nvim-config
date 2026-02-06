-- MUST BE FIRST
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Store for previous directory
local previous_dir = vim.fn.getcwd()

-- Plugins
require("lazy").setup({
    -- Catppuccin colorscheme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup()
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    
    -- Telescope (fuzzy finder)
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { 
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
        },
        config = function()
            require("telescope").setup({
                extensions = {
                    file_browser = {
                        theme = "ivy",
                        hijack_netrw = true,
                        mappings = {
                            ["i"] = {
                                -- Your custom insert mode mappings
                            },
                            ["n"] = {
                                -- Your custom normal mode mappings
                            },
                        },
                    },
                },
            })
            require("telescope").load_extension("file_browser")
        end,
    },
    
    -- Neo-tree (file explorer)
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    filtered_items = {
                        visible = true,
                        hide_dotfiles = false,
                        hide_gitignored = true,
                    },
                    follow_current_file = {
                        enabled = true,
                    },
                    use_libuv_file_watcher = true,
                    window = {
                        mappings = {
                            ["<space>"] = "none",
                            ["s"] = "open_split",
                            ["v"] = "open_vsplit",
                            ["S"] = function(state)
                                local node = state.tree:get_node()
                                if node.type == "directory" then
                                    vim.cmd("cd " .. node.path)
                                    vim.cmd("split")
                                    print("✓ Changed to directory in split: " .. node.path)
                                else
                                    state.commands.open_split(state)
                                end
                            end,
                            ["V"] = function(state)
                                local node = state.tree:get_node()
                                if node.type == "directory" then
                                    vim.cmd("cd " .. node.path)
                                    vim.cmd("vsplit")
                                    print("✓ Changed to directory in vsplit: " .. node.path)
                                else
                                    state.commands.open_vsplit(state)
                                end
                            end,
                        }
                    },
                    commands = {
                        open_split = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.cmd("split " .. path)
                        end,
                        open_vsplit = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.cmd("vsplit " .. path)
                        end,
                    }
                },
            })
            
            -- Keymap to open Neo-tree
            vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left<CR>", { desc = "Open file explorer" })
            vim.keymap.set("n", "<leader>E", ":Neotree filesystem reveal<CR>", { desc = "Open file explorer (float)" })
        end,
    },
    
    -- Git Integration
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "Gstatus", "Gcommit", "Gpush", "Gpull" },
    },
    
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = '+' },
                    change       = { text = '~' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    
                    vim.keymap.set('n', ']c', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, { expr = true, buffer = bufnr, desc = "Next hunk" })
                    
                    vim.keymap.set('n', '[c', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, { expr = true, buffer = bufnr, desc = "Prev hunk" })
                    
                    vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
                    vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
                    vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, { buffer = bufnr, desc = "Stage visual hunk" })
                    vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end, { buffer = bufnr, desc = "Reset visual hunk" })
                    vim.keymap.set('n', '<leader>hS', gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
                    vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
                    vim.keymap.set('n', '<leader>hR', gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
                    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
                    vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end, { buffer = bufnr, desc = "Blame line" })
                    vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle line blame" })
                    vim.keymap.set('n', '<leader>hd', gs.diffthis, { buffer = bufnr, desc = "Diff this" })
                    vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end, { buffer = bufnr, desc = "Diff this (~)" })
                    vim.keymap.set('n', '<leader>td', gs.toggle_deleted, { buffer = bufnr, desc = "Toggle deleted" })
                end
            })
        end,
    },
    
    -- Git blame line
    {
        "f-person/git-blame.nvim",
        config = function()
            require("gitblame").setup({
                enabled = true,
                message_template = "    <author> • <date> • <summary>",
                date_format = "%Y-%m-%d",
            })
        end,
    },
    
    -- Telescope git extensions
    {
        "nvim-telescope/telescope-github.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
    },
    
    -- Fuzzy finder performance
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },

    -- Treesitter (parser installer - Neovim 0.11 has built-in treesitter highlighting)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            vim.schedule(function()
                local parsers = { "java", "lua", "vim", "vimdoc", "query", "json", "xml", "yaml", "html", "css", "javascript", "typescript" }
                for _, lang in ipairs(parsers) do
                    pcall(vim.cmd, "TSInstall! " .. lang)
                end
            end)
        end,
    },

    -- Mason (LSP installer)
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "+",
                        package_pending = "~",
                        package_uninstalled = "-",
                    },
                },
            })
        end,
    },

    -- Mason LSPconfig bridge
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "jdtls", "lua_ls" },
            })
        end,
    },

    -- nvim-jdtls (Java-specific LSP with extra features)
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },

    -- Toggleterm (integrated terminal with splits)
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
                open_mapping = [[<C-\>]],
                hide_numbers = true,
                shade_terminals = true,
                shading_factor = 2,
                start_in_insert = true,
                insert_mappings = true,
                persist_size = true,
                direction = "horizontal",
                close_on_exit = true,
                shell = vim.o.shell,
                float_opts = {
                    border = "curved",
                    winblend = 0,
                },
            })

            -- Terminal keymaps
            function _G.set_terminal_keymaps()
                local topts = { buffer = 0 }
                vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], topts)
                vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], topts)
                vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], topts)
                vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], topts)
                vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], topts)
            end
            vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
        end,
    },
})

-- LSP setup (Neovim 0.11 native API)
local capabilities = (function()
    local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then return cmp_lsp.default_capabilities() end
    return vim.lsp.protocol.make_client_capabilities()
end)()

-- Lua LS config
vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        },
    },
})
vim.lsp.enable("lua_ls")

-- LSP keymaps (applied when any LSP attaches)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
    end,
})

-- Diagnostic config
vim.diagnostic.config({
    virtual_text = { prefix = ">" },
    signs = true,
    underline = true,
    update_in_insert = false,
    float = { border = "rounded" },
})

-- SET KEYMAPS HERE (after Lazy setup)
vim.schedule(function()
    -- Telescope keymaps
    local ok, builtin = pcall(require, "telescope.builtin")
    if ok then
        -- File operations
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
        vim.keymap.set("n", "<leader>fF", function()
            builtin.find_files({ cwd = vim.fn.expand("%:p:h") })
        end, { desc = "Find files (current dir)" })
        
        -- File browser for folder navigation
        vim.keymap.set("n", "<leader>fe", function()
            require("telescope").extensions.file_browser.file_browser({
                path = "%:p:h",
                grouped = true,
                initial_mode = "normal",
                hide_parent_dir = false,
                respect_gitignore = true,
            })
        end, { desc = "File browser (current dir)" })
        
        vim.keymap.set("n", "<leader>fE", function()
            require("telescope").extensions.file_browser.file_browser({
                grouped = true,
                initial_mode = "normal",
                hide_parent_dir = false,
                respect_gitignore = true,
            })
        end, { desc = "File browser (project)" })
        
        -- File browser with split opening capabilities
        vim.keymap.set("n", "<leader>fse", function()
            require("telescope").extensions.file_browser.file_browser({
                path = vim.fn.getcwd(),
                grouped = true,
                initial_mode = "normal",
                hide_parent_dir = false,
                respect_gitignore = true,
                previewer = false,
                layout_config = {
                    width = 0.8,
                    height = 0.8,
                },
                attach_mappings = function(prompt_bufnr, map)
                    local actions = require("telescope.actions")
                    local action_state = require("telescope.actions.state")
                    
                    -- Custom action: open in vertical split
                    map("i", "<C-v>", function()
                        local entry = action_state.get_selected_entry()
                        actions.close(prompt_bufnr)
                        if entry then
                            vim.cmd("vsplit " .. entry.path)
                        end
                    end)
                    
                    map("n", "<C-v>", function()
                        local entry = action_state.get_selected_entry()
                        actions.close(prompt_bufnr)
                        if entry then
                            vim.cmd("vsplit " .. entry.path)
                        end
                    end)
                    
                    -- Custom action: open in horizontal split
                    map("i", "<C-x>", function()
                        local entry = action_state.get_selected_entry()
                        actions.close(prompt_bufnr)
                        if entry then
                            vim.cmd("split " .. entry.path)
                        end
                    end)
                    
                    map("n", "<C-x>", function()
                        local entry = action_state.get_selected_entry()
                        actions.close(prompt_bufnr)
                        if entry then
                            vim.cmd("split " .. entry.path)
                        end
                    end)
                    
                    return true
                end
            })
        end, { desc = "File browser (open files in splits)" })
        
        -- Grep/search
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fG", function()
            builtin.live_grep({ cwd = vim.fn.expand("%:p:h") })
        end, { desc = "Live grep (current dir)" })
        
        vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Grep string under cursor" })
        
        -- Other Telescope functions
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
        vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps" })
        vim.keymap.set("n", "<leader>f:", builtin.command_history, { desc = "Command history" })
        
        -- Quick access
        vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
        vim.keymap.set("n", "<C-f>", builtin.live_grep, { desc = "Live grep" })
        
        -- Git Telescope extensions
        vim.keymap.set("n", "<leader>gg", builtin.git_status, { desc = "Git status" })
        vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
        vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
        vim.keymap.set("n", "<leader>gs", builtin.git_stash, { desc = "Git stash" })
        
        print("✓ Telescope keymaps set successfully")
    else
        print("⚠ Telescope not available yet")
    end
    
    -- Fugitive (Git) keymaps
    vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
    vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
    vim.keymap.set("n", "<leader>gP", ":Git pull<CR>", { desc = "Git pull" })
    vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
    vim.keymap.set("n", "<leader>gd", ":Gdiff<CR>", { desc = "Git diff" })
    vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
    
    -- Directory operations with window splitting
    vim.keymap.set("n", "<leader>cs", function()
        local dir = vim.fn.expand("%:p:h")
        vim.cmd("split")
        vim.cmd("cd " .. dir)
        print("✓ Split window & changed to: " .. dir)
    end, { desc = "Split window and change to current file's dir" })
    
    vim.keymap.set("n", "<leader>cv", function()
        local dir = vim.fn.expand("%:p:h")
        vim.cmd("vsplit")
        vim.cmd("cd " .. dir)
        print("✓ Vertically split & changed to: " .. dir)
    end, { desc = "Vertical split and change to current file's dir" })
    
    -- Change to specific directory with splitting
    vim.keymap.set("n", "<leader>cS", function()
        local dir = vim.fn.input("Change to directory (split): ", "", "dir")
        if dir ~= "" then
            vim.cmd("split")
            vim.cmd("cd " .. dir)
            print("✓ Split window & changed to: " .. dir)
        end
    end, { desc = "Split window and change to specified directory" })
    
    vim.keymap.set("n", "<leader>cV", function()
        local dir = vim.fn.input("Change to directory (vsplit): ", "", "dir")
        if dir ~= "" then
            vim.cmd("vsplit")
            vim.cmd("cd " .. dir)
            print("✓ Vertically split & changed to: " .. dir)
        end
    end, { desc = "Vertical split and change to specified directory" })
    
    -- Create and open directory in split
    vim.keymap.set("n", "<leader>ns", function()
        local dirname = vim.fn.input("New directory (open in split): ", "", "dir")
        if dirname ~= "" then
            vim.fn.mkdir(dirname, "p")
            vim.cmd("split")
            vim.cmd("cd " .. dirname)
            print("✓ Created, split, and changed to: " .. dirname)
        end
    end, { desc = "New directory and open in split window" })
    
    -- Navigate to parent directory in split
    vim.keymap.set("n", "<leader>-", function()
        local current_dir = vim.fn.getcwd()
        local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
        vim.cmd("split")
        vim.cmd("cd " .. parent_dir)
        print("✓ Split window & changed to parent: " .. parent_dir)
    end, { desc = "Split window and go to parent directory" })
    
    -- Navigate to parent directory in vsplit
    vim.keymap.set("n", "<leader>_", function()
        local current_dir = vim.fn.getcwd()
        local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
        vim.cmd("vsplit")
        vim.cmd("cd " .. parent_dir)
        print("✓ Vertical split & changed to parent: " .. parent_dir)
    end, { desc = "Vertical split and go to parent directory" })
    
    -- Directory navigation
    vim.keymap.set("n", "<leader>cd", function()
        local dir = vim.fn.expand("%:p:h")
        vim.cmd("cd " .. dir)
        print("✓ Changed to: " .. dir)
    end, { desc = "Change to current file's directory" })
    
    vim.keymap.set("n", "<leader>pwd", function()
        print("📁 Current directory: " .. vim.fn.getcwd())
    end, { desc = "Print working directory" })
    
    vim.keymap.set("n", "<leader>lcd", function()
        local dir = vim.fn.expand("%:p:h")
        vim.cmd("lcd " .. dir)
        print("✓ Changed local dir to: " .. dir)
    end, { desc = "Local change directory" })
    
    -- Quick switch between two directories
    vim.keymap.set("n", "<leader>cds", function()
        previous_dir = vim.fn.getcwd()
        local dir = vim.fn.expand("%:p:h")
        vim.cmd("split")
        vim.cmd("cd " .. dir)
        print("✓ Split & changed to: " .. dir)
    end, { desc = "Split and change to current file's dir, remember previous" })
    
    vim.keymap.set("n", "<leader>cdb", function()
        if previous_dir ~= "" then
            vim.cmd("split")
            vim.cmd("cd " .. previous_dir)
            print("✓ Split & changed back to: " .. previous_dir)
        else
            print("⚠ No previous directory stored")
        end
    end, { desc = "Split and change back to previous directory" })
    
    -- Toggle between current and previous directory in split
    vim.keymap.set("n", "<leader>cdt", function()
        local current_dir = vim.fn.getcwd()
        if previous_dir ~= current_dir then
            vim.cmd("split")
            vim.cmd("cd " .. previous_dir)
            previous_dir = current_dir
            print("✓ Split & toggled to previous directory")
        else
            print("⚠ Already in the only stored directory")
        end
    end, { desc = "Split and toggle between current/previous directory" })
    
    -- Create new file in current directory
    vim.keymap.set("n", "<leader>nf", function()
        local filename = vim.fn.input("New filename: ")
        if filename ~= "" then
            vim.cmd("e " .. filename)
        end
    end, { desc = "New file" })
    
    -- Create new directory
    vim.keymap.set("n", "<leader>nd", function()
        local dirname = vim.fn.input("New directory: ")
        if dirname ~= "" then
            vim.fn.mkdir(dirname, "p")
            print("✓ Created directory: " .. dirname)
        end
    end, { desc = "New directory" })
    
    -- Quick open config files
    vim.keymap.set("n", "<leader>vc", function()
        vim.cmd("e ~/.config/nvim/init.lua")
    end, { desc = "Open Neovim config" })
    
    -- Terminal keymaps (toggleterm)
    vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal (horizontal)" })
    vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Terminal (vertical)" })
    vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Terminal (float)" })
    vim.keymap.set("n", "<leader>t1", "<cmd>1ToggleTerm<CR>", { desc = "Terminal 1" })
    vim.keymap.set("n", "<leader>t2", "<cmd>2ToggleTerm<CR>", { desc = "Terminal 2" })
    vim.keymap.set("n", "<leader>t3", "<cmd>3ToggleTerm<CR>", { desc = "Terminal 3" })

    -- Test mapping
    vim.keymap.set("n", "<leader>tt", function()
        print("✓ Leader test: Works!")
    end, { desc = "Test leader" })

    print("✓ Leader mappings loaded. Use :Telescope keymaps to see them.")
end)

-- Autocommands for better file browsing
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "neo-tree", "TelescopePrompt", "fugitive" },
    callback = function()
        vim.cmd("setlocal nocursorline")
    end,
})

-- Show directory changes
vim.api.nvim_create_autocmd("DirChanged", {
    callback = function()
        vim.schedule(function()
            print("Directory changed to: " .. vim.fn.getcwd())
        end)
    end,
})

-- Helper function to save and restore window layout
function SaveWindowLayout()
    local layout = {
        cwd = vim.fn.getcwd(),
        windows = {}
    }
    
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local bufname = vim.api.nvim_buf_get_name(buf)
        if bufname ~= "" then
            table.insert(layout.windows, {
                file = bufname,
                winid = win
            })
        end
    end
    
    return layout
end

function RestoreWindowLayout(layout)
    vim.cmd("cd " .. layout.cwd)
    
    -- Close all windows except current
    local current_win = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if win ~= current_win then
            vim.api.nvim_win_close(win, false)
        end
    end
    
    -- Open files in splits
    for i, win_info in ipairs(layout.windows) do
        if i > 1 then  -- First window is already current
            if i % 2 == 0 then
                vim.cmd("split " .. win_info.file)
            else
                vim.cmd("vsplit " .. win_info.file)
            end
        end
    end
end

-- Save and restore workspace
local saved_layout = nil
vim.keymap.set("n", "<leader>ws", function()
    saved_layout = SaveWindowLayout()
    print("✓ Workspace layout saved")
end, { desc = "Save workspace layout" })

vim.keymap.set("n", "<leader>wr", function()
    if saved_layout then
        RestoreWindowLayout(saved_layout)
        print("✓ Workspace layout restored")
    else
        print("⚠ No workspace layout saved")
    end
end, { desc = "Restore workspace layout" })

-- Java JDTLS setup (auto-starts when opening .java files)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
        if not mason_registry_ok then return end

        local jdtls_ok, jdtls = pcall(require, "jdtls")
        if not jdtls_ok then return end

        local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()
        local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
        local config_dir = jdtls_path .. "/config_mac"

        -- Use project name for workspace
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

        local config = {
            cmd = {
                "java",
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xmx1g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens", "java.base/java.util=ALL-UNNAMED",
                "--add-opens", "java.base/java.lang=ALL-UNNAMED",
                "-jar", launcher,
                "-configuration", config_dir,
                "-data", workspace_dir,
            },
            root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
            settings = {
                java = {
                    signatureHelp = { enabled = true },
                    completion = {
                        favoriteStaticMembers = {
                            "org.junit.Assert.*",
                            "org.junit.jupiter.api.Assertions.*",
                            "java.util.Objects.requireNonNull",
                            "java.util.Objects.requireNonNullElse",
                        },
                    },
                    sources = {
                        organizeImports = {
                            starThreshold = 9999,
                            staticStarThreshold = 9999,
                        },
                    },
                },
            },
            capabilities = (function()
                local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
                if ok then return cmp_lsp.default_capabilities() end
                return vim.lsp.protocol.make_client_capabilities()
            end)(),
            on_attach = function(_, bufnr)
                -- Java-specific keymaps
                local opts = { buffer = bufnr }
                vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
                vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, opts)
                vim.keymap.set("v", "<leader>jv", function() jdtls.extract_variable(true) end, opts)
                vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, opts)
                vim.keymap.set("v", "<leader>jc", function() jdtls.extract_constant(true) end, opts)
                vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end, opts)
            end,
        }

        jdtls.start_or_attach(config)
    end,
})

-- Additional settings for VS Code-like experience
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 250

-- Window navigation (Ctrl+h/j/k/l to move between splits)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Resize splits with arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })