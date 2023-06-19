return {
    { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
    { "windwp/nvim-ts-autotag", dependencies = { "nvim-treesitter/nvim-treesitter" }, opts = {} },
    { "numToStr/Comment.nvim", dependencies = { "nvim-treesitter/nvim-treesitter" }, opts = {} },
    { "mbbill/undotree", config = function() vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle) end },
    {
        "folke/which-key.nvim",
        lazy = true,
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    }
}
