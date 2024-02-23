return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	-- Only load obsidian.nvim for markdown files in your vault:
	event = {
		"BufReadPre /home/canalejas/trash-notes/**/**.md",
		"BufNewFile /home/canalejas/trash-notes/**/**.md",
	},
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "/home/canalejas/trash-notes",
			},
		},
		--  * "current_dir" - put new notes in same directory as the current buffer.
		--  * "notes_subdir" - put new notes in the default notes subdirectory.
		new_notes_location = "current_dir",
		completion = {
			nvim_cmp = true,
			-- Trigger completion at 2 chars.
			min_chars = 2,
		},
		mappings = {
			-- "Obsidian follow"
			["<leader>gd"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			-- Toggle check-boxes "obsidian done"
			["<leader>od"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
		},

		note_frontmatter_func = function(note)
			-- This is equivalent to the default frontmatter function.
			local out = { id = note.id, aliases = note.aliases, tags = note.tags, area = "", project = "" }

			-- `note.metadata` contains any manually added fields in the frontmatter.
			-- So here we just make sure those fields are kept in the frontmatter.
			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end
			return out
		end,

		templates = {
			subdir = "Templates",
			date_format = "%Y-%m-%d-%a",
			time_format = "%H:%M",
			tags = "",
		},
	},
}
