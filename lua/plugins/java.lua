return {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
                if not mason_registry_ok then return end

                local jdtls_ok, jdtls = pcall(require, "jdtls")
                if not jdtls_ok then return end

                local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()
                local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
                local config_dir = jdtls_path .. "/config_mac"

                -- Use project name for workspace
                local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
                local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

                local config = {
                    cmd = {
                        "java",
                        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                        "-Dosgi.bundles.defaultStartLevel=4",
                        "-Declipse.product=org.eclipse.jdt.ls.core.product",
                        "-Dlog.protocol=true",
                        "-Dlog.level=ALL",
                        "-Xmx1g",
                        "--add-modules=ALL-SYSTEM",
                        "--add-opens", "java.base/java.util=ALL-UNNAMED",
                        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
                        "-jar", launcher,
                        "-configuration", config_dir,
                        "-data", workspace_dir,
                    },
                    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
                    settings = {
                        java = {
                            signatureHelp = { enabled = true },
                            completion = {
                                favoriteStaticMembers = {
                                    "org.junit.Assert.*",
                                    "org.junit.jupiter.api.Assertions.*",
                                    "java.util.Objects.requireNonNull",
                                    "java.util.Objects.requireNonNullElse",
                                },
                            },
                            sources = {
                                organizeImports = {
                                    starThreshold = 9999,
                                    staticStarThreshold = 9999,
                                },
                            },
                        },
                    },
                    capabilities = (function()
                        local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
                        if ok then return cmp_lsp.default_capabilities() end
                        return vim.lsp.protocol.make_client_capabilities()
                    end)(),
                    on_attach = function(_, bufnr)
                        local opts = { buffer = bufnr }
                        vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
                        vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, opts)
                        vim.keymap.set("v", "<leader>jv", function() jdtls.extract_variable(true) end, opts)
                        vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, opts)
                        vim.keymap.set("v", "<leader>jc", function() jdtls.extract_constant(true) end, opts)
                        vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end, opts)
                    end,
                }

                jdtls.start_or_attach(config)
            end,
        })
    end,
}
