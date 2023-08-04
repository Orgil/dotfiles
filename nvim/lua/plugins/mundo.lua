local map = require("utils").map

return {
	{
		"simnalamburt/vim-mundo",
		lazy = true,
		config = function()
			vim.g.mundo_right = 1
			vim.g.mundo_width = 60
			vim.g.mundo_preview_height = 40
			map("n", "<leader>fu", ":MundoToggle<CR>")
		end,
	},
}
