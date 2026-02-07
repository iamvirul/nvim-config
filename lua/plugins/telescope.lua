return {
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
                            ["i"] = {},
                            ["n"] = {},
                        },
                    },
                },
            })
            require("telescope").load_extension("file_browser")
        end,
    },

    {
        "nvim-telescope/telescope-github.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
}
