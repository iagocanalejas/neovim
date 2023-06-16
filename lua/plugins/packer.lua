-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Theme
    use {
        'catppuccin/nvim',
        as = 'catppuccin',
        config = function() vim.cmd('colorscheme catppuccin-macchiato') end
    }

    -- Code
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use {
        "folke/trouble.nvim",
        config = function() require("trouble").setup() end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use("nvim-treesitter/nvim-treesitter-context")
    use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' } -- Folding

    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    use {
        "windwp/nvim-ts-autotag",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function() require('nvim-ts-autotag').setup {} end
    }

    use("theprimeagen/harpoon")
    use("theprimeagen/refactoring.nvim")
    use("tpope/vim-fugitive")
    use("mbbill/undotree")

    use {
        'numToStr/Comment.nvim',
        config = function() require("Comment").setup() end
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'j-hui/fidget.nvim' },
            { 'folke/neodev.nvim' },
            { 'jose-elias-alvarez/null-ls.nvim' },
            { 'MunifTanjim/prettier.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }

    -- Visual
    use("NvChad/nvim-colorizer.lua")
    use {
        'folke/which-key.nvim',
        config = function() require("which-key").setup() end
    }

    use {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup({
                icons_enabled = false,
                theme = 'catppuccin-macchiato',
                component_separators = '|',
                section_separators = '',
            })
        end
    }

    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                char = '┊',
                show_trailing_blankline_indent = false,
            })
        end
    }

    -- Utils
    -- use("github/copilot.vim")
    use("nvim-treesitter/playground")
    use("eandrju/cellular-automaton.nvim")
end)
