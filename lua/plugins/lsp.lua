-- LSP Server Settings
---@type lspconfig.options
local servers = {
	jsonls = {
		-- lazy-load schemastore when needed
		on_new_config = function(new_config)
			new_config.settings.json.schemas = new_config.settings.json.schemas or {}
			vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
		end,
		settings = {
			json = {
				format = {
					enable = true,
				},
				validate = { enable = true },
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				workspace = {
					checkThirdParty = false,
				},
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	},
	marksman = {},
	tsserver = {
		settings = {
			typescript = {
				format = {
					indentSize = vim.o.shiftwidth,
					convertTabsToSpaces = vim.o.expandtab,
					tabSize = vim.o.tabstop,
				},
			},
			javascript = {
				format = {
					indentSize = vim.o.shiftwidth,
					convertTabsToSpaces = vim.o.expandtab,
					tabSize = vim.o.tabstop,
				},
			},
			completions = {
				completeFunctionCalls = true,
			},
		},
	},
	tailwindcss = {
		filetypes_exclude = { "markdown" },
	},
	prismals = {
		prismaFmtBinPath = "",
	},
	pyright = {},
	yamlls = {},
}

return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
		config = function()
			local lsp = require("lsp-zero")

			lsp.preset("recommended")

			lsp.ensure_installed(vim.tbl_keys(servers))

			-- Fix Undefined global 'vim'
			lsp.nvim_workspace()

			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local cmp_mappings = lsp.defaults.cmp_mappings({
				["<Cr>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			})

			cmp_mappings["<Tab>"] = nil
			cmp_mappings["<S-Tab>"] = nil

			lsp.setup_nvim_cmp({ mapping = cmp_mappings })

			lsp.set_preferences({
				suggest_lsp_servers = false,
				sign_icons = {
					error = "E",
					warn = "W",
					hint = "H",
					info = "I",
				},
			})

			lsp.on_attach(function(client, bufnr)
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, opts)
				vim.keymap.set("i", "<C-k>", function()
					vim.lsp.buf.signature_help()
				end, opts)
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover()
				end, opts)

				vim.keymap.set("n", "[d", function()
					vim.diagnostic.goto_next()
				end, opts)
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.goto_prev()
				end, opts)

				vim.keymap.set("n", "<leader>vws", function()
					vim.lsp.buf.workspace_symbol()
				end, opts)
				vim.keymap.set("n", "<leader>vca", function()
					vim.lsp.buf.code_action()
				end, opts)
				vim.keymap.set("n", "<leader>vrr", function()
					vim.lsp.buf.references()
				end, opts)
				vim.keymap.set("n", "<leader>vrn", function()
					vim.lsp.buf.rename()
				end, opts)
			end)

			lsp.setup()

			vim.diagnostic.config({ virtual_text = true })
		end,
	},

	-- Mason
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		opts = {
			ensure_installed = {
				"black",
				"mypy",
				"prettierd",
				"pyright",
				"ruff",
				"shfmt",
				"stylua",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")

			-- Install 'ensure_installed' packages
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},

	-- Null_ls
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "jose-elias-alvarez/typescript.nvim" },
		},
		opts = function()
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			local nls = require("null-ls")
			return {
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
				sources = {
					nls.builtins.diagnostics.fish,
					-- nls.builtins.diagnostics.mypy,
					nls.builtins.diagnostics.ruff.with({
						extra_args = { "--line-length=120" },
					}),

					nls.builtins.formatting.fish_indent,
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.shfmt,
					nls.builtins.formatting.prettierd.with({
						extra_args = { "--max_line_length=120" },
					}),
					nls.builtins.formatting.black.with({
						extra_args = { "--line-length=120" },
					}),
					require("typescript.extensions.null-ls.code-actions"),
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({
							group = augroup,
							buffer = bufnr,
						})
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			}
		end,
	},
}
