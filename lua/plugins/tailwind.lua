return {
  {
    "MaximilianLloyd/tw-values.nvim",
    keys = {
      { "<leader>sv", "<cmd>TWValues<cr>", desc = "Show tailwind CSS values" },
    },
    opts = {
      border = "rounded",
      show_unknown_classes = true,
      focus_preview = true,
      copy_register = "",
      keymaps = {
        copy = "<C-y>"
      }
    }
  },
  {
    'laytan/tailwind-sorter.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
    build = 'cd formatter && npm i && npm run build',
    config = function()
      require('tailwind-sorter').setup({
        on_save_enabled = true,
        on_save_pattern = { '*.html', '*ts', '*.tsx', '*.templ' },
        node_path = 'node',
      })
    end,
  },
}
