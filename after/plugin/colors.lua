require('catppuccin').setup({
    disable_background = true,
    transparent_background = false,
})

function ColorMyPencils(color)
	color = color or "catppuccin"
	vim.cmd.colorscheme(color)
end

ColorMyPencils()
