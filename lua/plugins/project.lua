return {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
        require("project_nvim").setup({
            -- Methods of detecting the root directory. **"lsp"** uses the native neovim
            -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
            -- order matters: if one is not detected, the other is used as fallback.
            detection_methods = { "lsp", "pattern" },

            -- All the patterns used to detect root dir, when **"pattern"** is in
            -- detection_methods
            patterns = { ".git", "Makefile", "package.json", "pom.xml", "build.gradle" },
            
            -- Show hidden files in telescope
            show_hidden = true,

            -- When set to false, you will get a message when project.nvim changes your
            -- directory.
            silent_chdir = true,
        })
    end,
}