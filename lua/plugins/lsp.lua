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
	ruff_lsp = {
		on_attach = function(client, bufnr)
			-- Enable completion triggered by <c-x><c-o>
			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
		end,
		settings = {
			args = { "--line-length=120" },
		},
	},
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
				local opts = { buffer = bufnr, noremap = true, silent = true }

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
			end)

			lsp.setup()

			-- setup all the servers
			local lspconfig = require("lspconfig")
			lspconfig.jsonls.setup(servers.jsonls)
			lspconfig.lua_ls.setup(servers.lua_ls)
			lspconfig.marksman.setup(servers.marksman)
			lspconfig.tsserver.setup(servers.tsserver)
			lspconfig.tailwindcss.setup(servers.tailwindcss)
			lspconfig.prismals.setup(servers.prismals)
			lspconfig.pyright.setup(servers.pyright)
			lspconfig.ruff_lsp.setup(servers.ruff_lsp)
			lspconfig.yamlls.setup(servers.yamlls)

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
				"prettierd",
				"pyright",
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
