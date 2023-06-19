return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local telescope = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = "[F]ind [F]ile" })
            vim.keymap.set('n', '<leader>fg', telescope.git_files, { desc = "[F]ind [G]it" })
            vim.keymap.set('n', '<leader>fs', function()
                telescope.grep_string({ search = vim.fn.input("Grep > ") })
            end, { desc = "[F]ile [S]earch" })
            vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = "Telescope help" })
        end
    },
    {
        "theprimeagen/harpoon",
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")

            vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "[A]dd Harpoon Marker" })
            vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle M[e]nu" })

            vim.keymap.set("n", "<C-a>", function() ui.nav_file(1) end, { desc = "Harpoon Navigate [1]" })
            vim.keymap.set("n", "<C-s>", function() ui.nav_file(2) end, { desc = "Harpoon Navigate [2]" })
            vim.keymap.set("n", "<C-d>", function() ui.nav_file(3) end, { desc = "Harpoon Navigate [3]" })
            vim.keymap.set("n", "<C-f>", function() ui.nav_file(4) end, { desc = "Harpoon Navigate [4]" })
        end
    }
}
