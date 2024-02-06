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

local kind_icons = {
	Text = ' ',
	Method = ' ',
	Function = ' ',
	Constructor = ' ',
	Field = ' ',
	Variable = ' ',
	Class = ' ',
	Interface = ' ',
	Module = ' ',
	Property = ' ',
	Snippet = ' ',
	Unit = ' ',
	Value = ' ',
	Enum = ' ',
	Keyword = ' ',
	Color = ' ',
	File = ' ',
	Reference = ' ',
	Folder = ' ',
	EnumMember = ' ',
	Constant = ' ',
	Struct = ' ',
	Event = ' ',
	Operator = ' ',
	TypeParameter = ' ',
}

return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
			{ "lukas-reineke/cmp-under-comparator" },
			{ "onsails/lspkind.nvim" },
			{ "windwp/nvim-ts-autotag" },
			{ "windwp/nvim-autopairs" },
		},
		config = function()
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			require("nvim-autopairs").setup({
				check_ts = true,
				enable_check_bracket_line = false,
			})

			-- Integrate nvim-autopairs with cmp
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			-- Load snippets
			require("luasnip/loaders/from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- select suggestion
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
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
					{ name = "luasnip", max_item_count = 3 },
					{ name = "buffer",  keyword_length = 3, max_item_count = 5 },
					{ name = "path",    max_item_count = 3 },
				}),
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
				enabled = function()
					local context = require("cmp.config.context")
					local disabled = false
					disabled = disabled or (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
					disabled = disabled or (vim.fn.reg_recording() ~= "")
					disabled = disabled or (vim.fn.reg_executing() ~= "")
					disabled = disabled or context.in_treesitter_capture("comment")
					return not disabled
				end,
				formatting = {
					expandable_indicator = true,
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						before = function(entry, vim_item)
							-- Kind icons
							vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
							-- Source
							vim_item.menu = ({
								buffer = "[Buffer]",
								nvim_lsp = "[LSP]",
								luasnip = "[LuaSnip]",
								nvim_lua = "[Lua]",
							})[entry.source.name]
							return vim_item
						end,
					}),
				},
				experimental = {
					ghost_text = true,
				},
			})
		end,
	},
}
