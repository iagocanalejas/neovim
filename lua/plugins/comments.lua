return {
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gc", mode = { "n", "v" }, desc = "Toggle comments (normal mode)" },
			{ "gb", mode = { "n", "v" }, desc = "Toggle block comments (normal mode)" },
		},
		config = true,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{
				"]t",
				function()
					return require("todo-comments").jump_next()
				end,
				desc = "Jump to next todo comment",
			},
			{
				"[t",
				function()
					return require("todo-comments").jump_prev()
				end,
				desc = "Jump to previous todo comment",
			},
			{ "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
			{
				"<leader>xT",
				"<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",
				desc = "Todo/Fix/Fixme (Trouble)",
			},
			{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
			{ "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
		},
		config = true,
	},
}
