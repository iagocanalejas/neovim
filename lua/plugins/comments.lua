return {
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
    keys = {
      {
        ']t',
        function()
          return require('todo-comments').jump_next()
        end,
        desc = 'Jump to next todo comment',
      },
      {
        '[t',
        function()
          return require('todo-comments').jump_prev()
        end,
        desc = 'Jump to previous todo comment',
      },
      { '<leader>ft', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme' },
    },
    config = true,
  },
  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gc', mode = { 'n', 'v' }, desc = 'Toggle comments (normal mode)' },
      { 'gb', mode = { 'n', 'v' }, desc = 'Toggle block comments (normal mode)' },
    },
    config = true,
  },
}

-- vim: ts=4 sts=4 sw=4 et
