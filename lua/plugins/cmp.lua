local disallowed_paths = { "*/build/*", "*/out/*", "*/dist/*" }

local function get_referenced_item_path(completion_item)
	local path = nil
	if completion_item.labelDetails then
		path = ""
		if completion_item.labelDetails.description then
			path = path .. completion_item.labelDetails.description
		end
	end
	return path
end

local match_path = function(patterns, path)
	-- modules, at least in python, separated by dot, unlike paths
	path = path:gsub("%.", "/")
	-- normalize to always start with slash
	if path:sub(1, 1) ~= "/" then
		path = "/" .. path
	end
	for _, pattern in ipairs(patterns) do
		-- Convert glob-like pattern to Lua pattern
		pattern = pattern:gsub("%*", ".*"):gsub("%-", "%%-"):gsub("%/", "/")
		-- Add anchors to start and end
		pattern = "^" .. pattern .. "$"

		if string.match(path, pattern) then
			return true
		else
		end
	end
	return false
end

return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip", },
			{ "rafamadriz/friendly-snippets" },
			{ "lukas-reineke/cmp-under-comparator" },
		},
		config = function()
			require("luasnip/loaders/from_vscode").lazy_load()
			local cmp = require("cmp")

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm(),
					["<Tab>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{
						name = "nvim_lsp",
						entry_filter = function(entry, ctx)
							local path = get_referenced_item_path(entry.completion_item)
							if path ~= nil then
								if match_path(disallowed_paths, path) then
									return false
								end
							end
							return true
						end,
					},
					{ name = "buffer", keyword_length = 3 },
					{ name = "luasnip" },
					{ name = "path" },
				}),
				-- TODO: i'm testing this
				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						require("cmp-under-comparator").under,
						cmp.config.compare.kind,
					},
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				experimental = {
					ghost_text = true,
				},
			})
		end,
	},
}
