return {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
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

        -- Terminal keymaps (inside terminal)
        function _G.set_terminal_keymaps()
            local topts = { buffer = 0 }
            vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], topts)
            vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], topts)
            vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], topts)
            vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], topts)
            vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], topts)
            vim.keymap.set("t", "<C-Up>", [[<Cmd>resize +2<CR>]], topts)
            vim.keymap.set("t", "<C-Down>", [[<Cmd>resize -2<CR>]], topts)
            vim.keymap.set("t", "<C-Left>", [[<Cmd>vertical resize -2<CR>]], topts)
            vim.keymap.set("t", "<C-Right>", [[<Cmd>vertical resize +2<CR>]], topts)
        end
        vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

        -- Normal mode keymaps
        vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Terminal horizontal" })
        vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Terminal vertical" })
        vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Terminal float" })
        vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=tab<cr>", { desc = "Terminal tab" })
        vim.keymap.set("n", "<leader>t1", "<cmd>1ToggleTerm<cr>", { desc = "Terminal 1" })
        vim.keymap.set("n", "<leader>t2", "<cmd>2ToggleTerm<cr>", { desc = "Terminal 2" })
        vim.keymap.set("n", "<leader>t3", "<cmd>3ToggleTerm<cr>", { desc = "Terminal 3" })
        vim.keymap.set("n", "<leader>t4", "<cmd>4ToggleTerm<cr>", { desc = "Terminal 4" })
        vim.keymap.set("n", "<leader>ta", "<cmd>ToggleTermToggleAll<cr>", { desc = "Toggle all terminals" })
    end,
}
