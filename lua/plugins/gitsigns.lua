return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      on_attach = function()
        local gs = package.loaded.gitsigns

        vim.keymap.set('n', '<leader>gh', gs.preview_hunk, { desc = 'Preview Hunk' })
        vim.keymap.set('n', '<leader>gd', gs.diffthis, { desc = 'Diff This' })
        vim.keymap.set('n', '<leader>gR', gs.reset_buffer, { desc = 'Reset Buffer' })
        vim.keymap.set('n', '<leader>gb', function()
          gs.blame_line { full = true }
        end, { desc = 'Blame Line' })
      end,
    },
  },
}
