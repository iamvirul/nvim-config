-- Autocommands for better file browsing
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "neo-tree", "fff", "fugitive" },
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
