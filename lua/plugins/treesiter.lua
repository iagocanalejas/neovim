return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'html',
        'javascript',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'rst',
        'tsx',
        'toml',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
        'json',
        'json5',
        'jsonc',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      sync_install = false,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'python' },
      },
      indent = { enable = true, disable = { 'python' } },
      autopairs = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
    },
  },
  {
    'chrisgrieser/nvim-puppeteer',
    lazy = false, -- plugin lazy-loads itself. Can also load on filetypes.
  },
}

-- vim: ts=4 sts=4 sw=4 et
