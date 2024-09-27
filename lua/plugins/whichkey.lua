-- return {
--   "folke/which-key.nvim",
--   event = "VeryLazy",
--   init = function()
--     vim.o.timeout = true
--     vim.o.timeoutlen = 300
--   end,
--   keys = {
--     "<leader>",
--     '"',
--     "'",
--     "`",
--     "c",
--     "y",
--     "d",
--   },
--   opts = {
--     prefix = "",
--     buffer = nil,
--     silent = true,
--     noremap = true,
--     nowait = true,
--     defaults = {
--       mode = { "n", "v" },
--       ["g"] = { name = "+goto" },
--       ["gz"] = { name = "+surround" },
--       ["]"] = { name = "+next" },
--       ["["] = { name = "+prev" },
--       ["<leader><tab>"] = { name = "+tabs" },
--       ["<leader>b"] = { name = "+buffer" },
--       ["<leader>c"] = { name = "+code" },
--       ["<leader>g"] = { name = "+git" },
--       ["<leader>gh"] = { name = "+hunks" },
--       ["<leader>q"] = { name = "+quit/session" },
--       ["<leader>u"] = { name = "+ui" },
--       ["<leader>w"] = { name = "+windows" },
--       ["<leader>x"] = { name = "+diagnostics/quickfix" },
--     },
--   },
--   config = function(_, opts)
--     local wk = require("which-key")
--     wk.setup(opts)
--     wk.register(opts.defaults)
--   end,
-- }

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "g",             function() end, desc = "+goto" },
    { "gz",            function() end, desc = "+surround" },
    { "]",             function() end, desc = "+next" },
    { "[",             function() end, desc = "+prev" },
    { "<leader><tab>", function() end, desc = "+tabs" },
    { "<leader>b",     function() end, desc = "+buffer" },
    { "<leader>c",     function() end, desc = "+code" },
    { "<leader>f",     function() end, desc = "+find" },
    { "<leader>g",     function() end, desc = "+git" },
    { "<leader>gh",    function() end, desc = "+hunks" },
    { "<leader>q",     function() end, desc = "+quit/session" },
    { "<leader>u",     function() end, desc = "+ui" },
    { "<leader>w",     function() end, desc = "+windows" },
    { "<leader>x",     function() end, desc = "+diagnostics/quickfix" },
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
