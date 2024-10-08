return {
  -- {
  -- 	"kevinhwang91/nvim-ufo",
  -- 	dependencies = "kevinhwang91/promise-async",
  -- 	event = "VimEnter",
  -- 	keys = {
  -- 		-- stylua: ignore start
  -- 		{ "zm", function() require("ufo").closeAllFolds() end, desc = " 󱃄 Close All Folds" },
  -- 		{ "zr", function() require("ufo").openFoldsExceptKinds { "comment", "imports" } end, desc = " 󱃄 Open All Regular Folds" },
  -- 		{ "zR", function() require("ufo").openFoldsExceptKinds {} end, desc = " 󱃄 Open All Folds" },
  -- 		{ "z1", function() require("ufo").closeFoldsWith(1) end, desc = " 󱃄 Close L1 Folds" },
  -- 		{ "z2", function() require("ufo").closeFoldsWith(2) end, desc = " 󱃄 Close L2 Folds" },
  -- 		{ "z3", function() require("ufo").closeFoldsWith(3) end, desc = " 󱃄 Close L3 Folds" },
  -- 		{ "z4", function() require("ufo").closeFoldsWith(4) end, desc = " 󱃄 Close L4 Folds" },
  -- 		-- stylua: ignore end
  -- 	},
  -- 	config = function()
  -- 		-- INFO fold commands usually change the foldlevel, which fixes folds, e.g.
  -- 		-- auto-closing them after leaving insert mode, however ufo does not seem to
  -- 		-- have equivalents for zr and zm because there is no saved fold level.
  -- 		-- Consequently, the vim-internal fold levels need to be disabled by setting
  -- 		-- them to 99
  -- 		vim.opt.foldlevel = 99
  -- 		vim.opt.foldlevelstart = 99
  --
  -- 		require("ufo").setup({
  -- 			provider_selector = function(_, _, _)
  -- 				return { "treesitter", "indent" }
  -- 			end,
  -- 			-- when opening the buffer, close these fold kinds
  -- 			-- use `:UfoInspect` to get available fold kinds from the LSP
  -- 			close_fold_kinds_for_ft = { "imports", "comment" },
  -- 			open_fold_hl_timeout = 800,
  -- 		})
  -- 	end,
  -- },
}
