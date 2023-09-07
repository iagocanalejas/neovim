local function get_base_opts()
    local opts = {}
    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_ok then
        opts.capabilities = cmp_nvim_lsp.default_capabilities()
    end
    return opts
end

local function override_opts(overriden)
    return vim.tbl_deep_extend("force", get_base_opts(), overriden)
end

local handlers = {
    function(server_name)
        require("lspconfig")[server_name].setup(get_base_opts())
    end,

    ["gopls"] = function()
        require("lspconfig").gopls.setup(override_opts {
            settings = {
                gopls = {
                    gofumpt = true,
                    usePlaceholders = true,
                    analyses = {
                        unusedparams = true,
                    }
                }
            }
        })
    end,

    ['jsonls'] = function()
        require("lspconfig").jsonls.setup(override_opts {
            -- lazy-load schemastore when needed
            on_new_config = function(new_config)
                new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
            end,
            settings = {
                json = {
                    format = {
                        enable = true,
                    },
                    validate = { enable = true },
                },
            }
        })
    end,

    ['lua_ls'] = function()
        require("lspconfig").lua_ls.setup(override_opts {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' }
                    },
                    workspace = {
                        checkThirdParty = false,
                    },
                    completion = {
                        callSnippet = "Replace",
                    },
                }
            }
        })
    end,

    ['tsserver'] = function()
        require("lspconfig").tsserver.setup(override_opts {
            settings = {
                typescript = {
                    format = {
                        indentSize = 4,
                        convertTabsToSpaces = false,
                        tabSize = 4,
                    },
                },
                javascript = {
                    format = {
                        indentSize = 4,
                        convertTabsToSpaces = false,
                        tabSize = 4,
                    },
                },
                completions = {
                    completeFunctionCalls = true,
                },
            },
        })
    end,

    ['tailwindcss'] = function()
        require("lspconfig").tailwindcss.setup(override_opts {
            filetypes_exclude = { "markdown" },
        })
    end,

    ['pyright'] = function()
        -- disable diagnostics here. all diagnostics are in mypy & ruff
        require("lspconfig").pyright.setup(override_opts {})
    end,

    ['ruff_lsp'] = function()
        require("lspconfig").ruff_lsp.setup(override_opts {
            on_attach = function(client, bufnr)
                -- Disable hover in favor of Pyright
                client.server_capabilities.hoverProvider = false
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            end,
            settings = {
                args = { "--line-length=120" },
            },
        })
    end,

    ['svelte'] = function()
        require("lspconfig").svelte.setup(override_opts {})
    end
}

return {
    {
        "williamboman/mason.nvim",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        build = ":MasonUpdate", -- :MasonUpdate updates registry contents
        config = function()
            require("mason").setup()
            local mr = require("mason-registry")

            local packages = { "black", "prettierd", "pyright", "shfmt", "stylua" }
            local function ensure_installed()
                for _, tool in ipairs(packages) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "gopls",
                    "jsonls",
                    "lua_ls",
                    "marksman",
                    "tsserver",
                    "tailwindcss",
                    "pyright",
                    "ruff_lsp",
                    "yamlls"
                },
                automatic_installation = true,
                handlers = handlers,
            })
        end,
    },
}
