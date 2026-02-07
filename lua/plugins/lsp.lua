return {
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

    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "jdtls", "lua_ls" },
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
        end,
    },
}
