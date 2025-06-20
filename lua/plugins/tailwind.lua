return {
  {
    'MaximilianLloyd/tw-values.nvim',
    keys = {
      { '<leader>sv', '<cmd>TWValues<cr>', desc = 'Show tailwind CSS values' },
    },
    opts = {
      border = 'rounded',
      show_unknown_classes = true,
      focus_preview = true,
      copy_register = '',
      keymaps = {
        copy = '<C-y>',
      },
    },
  },
}
