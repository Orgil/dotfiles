local opt = vim.o
local g = vim.g

opt.mouse = "a"
opt.background = "dark"
opt.encoding = "utf-8"
opt.number = true
opt.cursorline = true
opt.synmaxcol = 300 -- stop syntax highlighting long lines
opt.tabstop = 2
opt.expandtab = true
opt.softtabstop = 2
opt.showtabline = 2
-- opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
vim.opt.shortmess:append({ W = true, I = true, c = true })
vim.opt.fillchars:append("fold:•")
-- opt.foldenable = true
-- opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99 -- nvim-ufo: start with all folds open
opt.signcolumn = "yes"
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.nvim/undo")
opt.undolevels = 10000
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.updatetime = 100
opt.hidden = true
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.autoindent = true
opt.incsearch = true
-- vim.o.smartindent = true
-- vim.o.indentexpr = ""
-- opt.cindent = true
opt.smartindent = true
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.errorbells = false
opt.wrap = false
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 0
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.laststatus = 0
opt.pumblend = 10 -- Popup blend
opt.pumheight = 20 -- Maximum number of entries in a popup

if vim.fn.has("nvim-0.9.0") == 1 then
	opt.splitkeep = "screen"
	vim.opt.shortmess:append({ C = true })
end

-- Big files: skip the expensive stuff (folds, indent guides, rainbow); syntax highlight stays, capped by synmaxcol
-- Huge files additionally skip the LSP
local bigfile_size = 256 * 1024 -- 256KB
local hugefile_size = 2 * 1024 * 1024 -- 2MB

vim.api.nvim_create_autocmd("BufReadPre", {
	callback = function(args)
		local ok, stat = pcall(vim.uv.fs_stat, args.file)
		if ok and stat and stat.size > bigfile_size then
			vim.b[args.buf].bigfile = true
			vim.b[args.buf].hugefile = stat.size > hugefile_size
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.cursorline = false
			vim.opt_local.swapfile = false
			vim.opt_local.undofile = false
			vim.opt_local.spell = false
		end
	end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
	callback = function(args)
		if not vim.b[args.buf].bigfile then
			return
		end
		vim.opt_local.foldmethod = "manual"
		pcall(function()
			require("ufo").detach(args.buf)
		end)
		pcall(function()
			require("ibl").setup_buffer(args.buf, { enabled = false })
		end)
		pcall(function()
			require("rainbow-delimiters").disable(args.buf)
		end)
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		if vim.b[args.buf].hugefile then
			vim.schedule(function()
				vim.lsp.buf_detach_client(args.buf, args.data.client_id)
			end)
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*" },
	callback = function(args)
		if not vim.b[args.buf].bigfile then
			vim.cmd("normal zx")
		end
	end,
})

-- Fix markdown indentation settings
g.markdown_recommended_style = 0
