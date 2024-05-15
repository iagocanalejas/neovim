return {
	"theprimeagen/harpoon",
	branch = "harpoon2",
	opts = {
		exclude_filetyes = { "gitcommit" },
	},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup({
			settings = {
				save_on_toggle = true,
			}
		})

		vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
		vim.keymap.set("n", "<A-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

		vim.keymap.set("n", "<A-a>", function() harpoon:list():select(1) end)
		vim.keymap.set("n", "<A-s>", function() harpoon:list():select(2) end)
		vim.keymap.set("n", "<A-d>", function() harpoon:list():select(3) end)
		vim.keymap.set("n", "<A-f>", function() harpoon:list():select(4) end)
	end,
}
