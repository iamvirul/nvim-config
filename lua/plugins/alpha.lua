return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            [[   _                      _            _  _____ _          _ _ ]],
            [[  (_)                    (_)          | |/ ____| |        | | |]],
            [[   _  __ _ _ __ _____   ___ _ __ _   _| | (___ | |__   ___| | |]],
            [[  | |/ _` | '_ ` _ \ \ / / | '__| | | | |\___ \| '_ \ / _ \ | |]],
            [[  | | (_| | | | | | \ V /| | |  | |_| | |____) | | | |  __/ | |]],
            [[  |_|\__,_|_| |_| |_|\_/ |_|_|   \__,_|_|_____/|_| |_|\___|_|_|]],
            [[                                                                ]],
        }

        dashboard.section.buttons.val = {
            dashboard.button("f", "  Find file", ":lua require('fff').find_files()<CR>"),
            dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("t", "󰊄  Find text", ":lua require('fff').live_grep()<CR>"),
            dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
            dashboard.button("q", "󰅚  Quit Neovim", ":qa<CR>"),
        }

        alpha.setup(dashboard.opts)
    end,
}
