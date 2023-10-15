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
			"<A-e>",
			function()
				return require("harpoon.ui").toggle_quick_menu()
			end,
			desc = "Toggle M[e]nu",
		},
		{
			"<A-a>",
			function()
				return require("harpoon.ui").nav_file(1)
			end,
			desc = "Harpoon Navigate [1]",
		},
		{
			"<A-s>",
			function()
				return require("harpoon.ui").nav_file(2)
			end,
			desc = "Harpoon Navigate [2]",
		},
		{
			"<A-d>",
			function()
				return require("harpoon.ui").nav_file(3)
			end,
			desc = "Harpoon Navigate [3]",
		},
		{
			"<A-f>",
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
