return {
	{
		"windwp/nvim-autopairs",
		dependencies = { "hrsh7th/nvim-cmp" },
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
				enable_check_bracket_line = false,
			})
			-- If you want to automatically add `(` after selecting a function or method
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = true
	},
	{
		'laytan/tailwind-sorter.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
		build = 'cd formatter && npm i && npm run build',
		config = function()
			require('tailwind-sorter').setup({
				on_save_enabled = true,                                  -- If `true`, automatically enables on save sorting.
				on_save_pattern = { '*.html', '*.js', '*.jsx', '*.tsx', '*.templ' }, -- The file patterns to watch and sort.
				node_path = 'node',
			})
		end,
	},
}
