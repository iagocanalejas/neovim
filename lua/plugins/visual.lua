return {
    { "NvChad/nvim-colorizer.lua",      opts = {} },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup({
                icons_enabled = false,
                theme = 'catppuccin-macchiato',
                component_separators = '|',
                section_separators = '',
            })
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                char = '┊',
                show_trailing_blankline_indent = false,
            })
        end
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
            local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
            for _, ls in ipairs(language_servers) do
                require('lspconfig')[ls].setup({
                    capabilities = capabilities
                    -- you can add other fields for setting up lsp server in this table
                })
            end

            require('ufo').setup()

            vim.o.foldcolumn = '1' -- '0' is not bad
            vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end
    },
    {
        'VonHeikemen/fine-cmdline.nvim',
        dependencies = {
            { 'MunifTanjim/nui.nvim' }
        },
        config = function ()
            vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', {noremap = true})
        end
    },
    { "eandrju/cellular-automaton.nvim" },
}
