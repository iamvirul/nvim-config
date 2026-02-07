-- Store for previous directory
local previous_dir = vim.fn.getcwd()

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

        print("Telescope keymaps set successfully")
    else
        print("Telescope not available yet")
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
        print("Split window & changed to: " .. dir)
    end, { desc = "Split window and change to current file's dir" })

    vim.keymap.set("n", "<leader>cv", function()
        local dir = vim.fn.expand("%:p:h")
        vim.cmd("vsplit")
        vim.cmd("cd " .. dir)
        print("Vertically split & changed to: " .. dir)
    end, { desc = "Vertical split and change to current file's dir" })

    -- Change to specific directory with splitting
    vim.keymap.set("n", "<leader>cS", function()
        local dir = vim.fn.input("Change to directory (split): ", "", "dir")
        if dir ~= "" then
            vim.cmd("split")
            vim.cmd("cd " .. dir)
            print("Split window & changed to: " .. dir)
        end
    end, { desc = "Split window and change to specified directory" })

    vim.keymap.set("n", "<leader>cV", function()
        local dir = vim.fn.input("Change to directory (vsplit): ", "", "dir")
        if dir ~= "" then
            vim.cmd("vsplit")
            vim.cmd("cd " .. dir)
            print("Vertically split & changed to: " .. dir)
        end
    end, { desc = "Vertical split and change to specified directory" })

    -- Create and open directory in split
    vim.keymap.set("n", "<leader>ns", function()
        local dirname = vim.fn.input("New directory (open in split): ", "", "dir")
        if dirname ~= "" then
            vim.fn.mkdir(dirname, "p")
            vim.cmd("split")
            vim.cmd("cd " .. dirname)
            print("Created, split, and changed to: " .. dirname)
        end
    end, { desc = "New directory and open in split window" })

    -- Navigate to parent directory in split
    vim.keymap.set("n", "<leader>-", function()
        local current_dir = vim.fn.getcwd()
        local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
        vim.cmd("split")
        vim.cmd("cd " .. parent_dir)
        print("Split window & changed to parent: " .. parent_dir)
    end, { desc = "Split window and go to parent directory" })

    -- Navigate to parent directory in vsplit
    vim.keymap.set("n", "<leader>_", function()
        local current_dir = vim.fn.getcwd()
        local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
        vim.cmd("vsplit")
        vim.cmd("cd " .. parent_dir)
        print("Vertical split & changed to parent: " .. parent_dir)
    end, { desc = "Vertical split and go to parent directory" })

    -- Directory navigation
    vim.keymap.set("n", "<leader>cd", function()
        local dir = vim.fn.expand("%:p:h")
        vim.cmd("cd " .. dir)
        print("Changed to: " .. dir)
    end, { desc = "Change to current file's directory" })

    vim.keymap.set("n", "<leader>pwd", function()
        print("Current directory: " .. vim.fn.getcwd())
    end, { desc = "Print working directory" })

    vim.keymap.set("n", "<leader>lcd", function()
        local dir = vim.fn.expand("%:p:h")
        vim.cmd("lcd " .. dir)
        print("Changed local dir to: " .. dir)
    end, { desc = "Local change directory" })

    -- Quick switch between two directories
    vim.keymap.set("n", "<leader>cds", function()
        previous_dir = vim.fn.getcwd()
        local dir = vim.fn.expand("%:p:h")
        vim.cmd("split")
        vim.cmd("cd " .. dir)
        print("Split & changed to: " .. dir)
    end, { desc = "Split and change to current file's dir, remember previous" })

    vim.keymap.set("n", "<leader>cdb", function()
        if previous_dir ~= "" then
            vim.cmd("split")
            vim.cmd("cd " .. previous_dir)
            print("Split & changed back to: " .. previous_dir)
        else
            print("No previous directory stored")
        end
    end, { desc = "Split and change back to previous directory" })

    -- Toggle between current and previous directory in split
    vim.keymap.set("n", "<leader>cdt", function()
        local current_dir = vim.fn.getcwd()
        if previous_dir ~= current_dir then
            vim.cmd("split")
            vim.cmd("cd " .. previous_dir)
            previous_dir = current_dir
            print("Split & toggled to previous directory")
        else
            print("Already in the only stored directory")
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
            print("Created directory: " .. dirname)
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
        print("Leader test: Works!")
    end, { desc = "Test leader" })

    print("Leader mappings loaded. Use :Telescope keymaps to see them.")
end)

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
        if i > 1 then
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
    print("Workspace layout saved")
end, { desc = "Save workspace layout" })

vim.keymap.set("n", "<leader>wr", function()
    if saved_layout then
        RestoreWindowLayout(saved_layout)
        print("Workspace layout restored")
    else
        print("No workspace layout saved")
    end
end, { desc = "Restore workspace layout" })
