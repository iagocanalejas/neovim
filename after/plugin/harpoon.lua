local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "[A]dd Harpoon Marker" })
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle M[e]nu" })

vim.keymap.set("n", "<C-a>", function() ui.nav_file(1) end, { desc = "Harpoon Navigate [1]" })
vim.keymap.set("n", "<C-s>", function() ui.nav_file(2) end, { desc = "Harpoon Navigate [2]" })
vim.keymap.set("n", "<C-d>", function() ui.nav_file(3) end, { desc = "Harpoon Navigate [3]" })
vim.keymap.set("n", "<C-f>", function() ui.nav_file(4) end, { desc = "Harpoon Navigate [4]" })

