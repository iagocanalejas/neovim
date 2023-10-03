return {
    "theprimeagen/harpoon",
    keys = {
        {
            "<leader>a",
            function()
                return require("harpoon.mark").add_file()
            end,
            desc = "[A]dd Harpoon Marker",
        },
        {
            "<C-e>",
            function()
                return require("harpoon.ui").toggle_quick_menu()
            end,
            desc = "Toggle M[e]nu",
        },
        {
            "<C-a>",
            function()
                return require("harpoon.ui").nav_file(1)
            end,
            desc = "Harpoon Navigate [1]",
        },
        {
            "<C-s>",
            function()
                return require("harpoon.ui").nav_file(2)
            end,
            desc = "Harpoon Navigate [2]",
        },
        {
            "<C-d>",
            function()
                return require("harpoon.ui").nav_file(3)
            end,
            desc = "Harpoon Navigate [3]",
        },
        {
            "<C-f>",
            function()
                return require("harpoon.ui").nav_file(4)
            end,
            desc = "Harpoon Navigate [4]",
        },
    },
    opts = {
        exclude_filetyes = { "gitcommit" },
    },
    config = true,
}
