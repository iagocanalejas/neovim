return {
    { -- TODO: remove as it's deprecated
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = function()
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            local nls = require("null-ls")
            return {
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),

                sources = {
                    nls.builtins.formatting.prettierd.with({
                        extra_args = { "--max_line_length=120", "--print-width=120" },
                    }),
                    nls.builtins.formatting.black.with({
                        extra_args = { "--line-length=120" },
                    }),
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
