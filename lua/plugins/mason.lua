local function get_base_opts()
  local opts = {}
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    opts.capabilities = cmp_nvim_lsp.default_capabilities()
  end
  return opts
end

local function override_opts(overriden)
  return vim.tbl_deep_extend("force", get_base_opts(), overriden)
end

local function filter(arr, func)
  -- Filter in place
  -- https://stackoverflow.com/questions/49709998/how-to-filter-a-lua-array-inplace
  local new_index = 1
  local size_orig = #arr
  for old_index, v in ipairs(arr) do
    if func(v, old_index) then
      arr[new_index] = v
      new_index = new_index + 1
    end
  end
  for i = new_index, size_orig do arr[i] = nil end
end

local function pyright_accessed_filter(diagnostic)
  -- Allow kwargs to be unused, sometimes you want many functions to take the
  -- same arguments but you don't use all the arguments in all the functions,
  -- so kwargs is used to suck up all the extras
  if diagnostic.message == '"kwargs" is not accessed' then
    return false
  end

  if diagnostic.message == '"args" is not accessed' then
    return false
  end

  -- Allow variables starting with an underscore
  if string.match(diagnostic.message, '"_.+" is not accessed') then
    return false
  end

  return true
end

local function custom_on_publish_diagnostics(a, params, client_id, c, config)
  filter(params.diagnostics, pyright_accessed_filter)
  vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
end

local handlers = {
  function(server_name)
    require("lspconfig")[server_name].setup(get_base_opts())
  end,

  ["gopls"] = function()
    require("lspconfig").gopls.setup(override_opts {
      settings = {
        gopls = {
          gofumpt = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          }
        }
      }
    })
  end,

  ['htmx'] = function()
    require("lspconfig").htmx.setup(override_opts {
      filetypes = { "html", "templ" }
    })
  end,

  ['jsonls'] = function()
    require("lspconfig").jsonls.setup(override_opts {
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
      }
    })
  end,

  ['lua_ls'] = function()
    require("lspconfig").lua_ls.setup(override_opts {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          },
          workspace = {
            checkThirdParty = false,
          },
          completion = {
            callSnippet = "Replace",
          },
        }
      }
    })
  end,

  ['ts_ls'] = function()
    require("lspconfig").ts_ls.setup(override_opts {
      settings = {
        typescript = {
          format = {
            indentSize = 4,
            convertTabsToSpaces = false,
            tabSize = 4,
          },
        },
        javascript = {
          format = {
            indentSize = 4,
            convertTabsToSpaces = false,
            tabSize = 4,
          },
        },
        completions = {
          completeFunctionCalls = true,
        },
      },
    })
  end,

  ['tailwindcss'] = function()
    require("lspconfig").tailwindcss.setup(override_opts {
      init_options = {
        userLanguages = {
          templ = "html",
        },
      },
      settings = {
        includeLanguages = {
          templ = "html",
        },
        validate = true,
      },
      filetypes = {
        "django-html", "htmldjango", "gohtml", "gohtmltmpl", "html",
        "css", "less", "postcss", "sass", "scss",
        "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "templ",
      },
    })
  end,

  ['pyright'] = function()
    require("lspconfig").pyright.setup(override_opts {
      on_attach = function(client, bufnr)
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(custom_on_publish_diagnostics, {})
      end,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "workspace",
            exclude = { "**/build", "**/venv", "venv", "build" },
          },
        },
      },
    })
  end,

  ['ruff_lsp'] = function()
    require("lspconfig").ruff_lsp.setup(override_opts {
      on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        -- Enable import sorting
        vim.keymap.set(
          'n',
          '<leader>o',
          function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.organizeImports" },
                diagnostics = {},
              },
            })
          end,
          { desc = "Organize Imports" })
      end,
      settings = {
        hoverProvider = false,
        args = { "--line-length=120" },
      },
    })
  end,
}

return {
  {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
    config = function()
      require("mason").setup()
      local mr = require("mason-registry")

      local packages = { "prettierd", "pyright", "shfmt", "stylua" }
      local function ensure_installed()
        for _, tool in ipairs(packages) do
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

      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "jsonls",
          "lua_ls",
          "marksman",
          "ts_ls",
          "tailwindcss",
          "pyright",
          "ruff_lsp",
          "yamlls"
        },
        automatic_installation = true,
        handlers = handlers,
      })
    end,
  },
}
