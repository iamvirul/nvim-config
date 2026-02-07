return {
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
                                print("Changed to directory in split: " .. node.path)
                            else
                                state.commands.open_split(state)
                            end
                        end,
                        ["V"] = function(state)
                            local node = state.tree:get_node()
                            if node.type == "directory" then
                                vim.cmd("cd " .. node.path)
                                vim.cmd("vsplit")
                                print("Changed to directory in vsplit: " .. node.path)
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

        vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left<CR>", { desc = "Open file explorer" })
        vim.keymap.set("n", "<leader>E", ":Neotree filesystem reveal<CR>", { desc = "Open file explorer (float)" })
    end,
}
