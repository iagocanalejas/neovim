local opt = vim.opt

opt.autowrite = true          -- Enable auto write
opt.backup = false
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.colorcolumn = "120"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3           -- Hide * markup for bold and italic
opt.confirm = true             -- Confirm to save changes before exiting modified buffer
opt.cursorline = true          -- Enable highlighting of the current line
opt.expandtab = false          -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.guicursor = ""
opt.ignorecase = true      -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 0
opt.list = true            -- Show some invisible characters (tabs...
opt.mouse = "a"            -- Enable mouse mode
opt.nu = true
opt.number = true          -- Print line number
opt.pumblend = 10          -- Popup blend
opt.pumheight = 15         -- Maximum number of entries in a popup
opt.relativenumber = true  -- Relative line numbers
opt.scrolloff = 8          -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true      -- Round indent
opt.shiftwidth = 4         -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true })
opt.showmode = false       -- Dont show mode since we have a statusline
opt.sidescrolloff = 8      -- Columns of context
opt.signcolumn = "yes"     -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true       -- Don't ignore case with capitals
opt.smartindent = true     -- Insert indents automatically
opt.spelllang = { "en", "es" }
opt.splitbelow = true      -- Put new windows below current
opt.splitright = true      -- Put new windows right of current
opt.softtabstop = 4
opt.swapfile = false
opt.tabstop = 4          -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200               -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5                -- Minimum window width
opt.wrap = false                   -- Disable line wrap

opt.splitkeep = "screen"
opt.shortmess:append { C = true }
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- evaluated for each line to obtain its fold level
opt.foldtext = "v:lua.vim.treesitter.foldtext()" -- evaluated to obtain the text displayed for a closed fold

local global = vim.g

global.markdown_recommended_style = 0                                                    -- Fix markdown indentation settings
global.netrw_banner = false                                                              -- Disable banner
global.netrw_altv = 1                                                                    -- Open with right splitting
global.netrw_liststyle = 4
global.netrw_list_hide = (vim.fn["netrw_gitignore#Hide"]()) .. [[,\(^\|\s\s\)\zs\.\S\+]] -- use .gitignore


-- additional filetypes
vim.filetype.add({
	extension = {
		templ = "templ",
	},
})
