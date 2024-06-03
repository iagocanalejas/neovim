return {
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      -- TODO: learn to use loclist and quickfix
      -- { "<leader>xl", "<cmd>TroubleToggle loclist<cr>",                              desc = "Location List (Trouble)" },
      -- { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",                             desc = "Quickfix List (Trouble)" },

      { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",  desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xw", "<cmd>Trouble diagnostics toggle focus=true<cr>",               desc = "Diagnostics (Trouble)" },
      { "<leader>xr", "<cmd>Trouble lsp_references focus=true<cr>",                   desc = "References (Trouble)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=true win.position=left<cr>", desc = "Symbols (Trouble)" },
      { "<leader>xc", function() require("trouble").close() end,                      desc = "Close (Trouble)" },
    },
    config = true,
  },
}
