return {
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
}
