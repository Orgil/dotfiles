local opt = vim.opt
local g = vim.g

opt.mouse = "a"
opt.background = "dark"
opt.encoding = "utf-8"
opt.number = true
opt.cursorline = true
opt.tabstop = 2
opt.expandtab = true
opt.softtabstop = 2
opt.showtabline = 2
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true })
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
	opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
g.markdown_recommended_style = 0
