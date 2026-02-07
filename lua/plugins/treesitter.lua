return {
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
}
