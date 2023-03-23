local map = require("utils").map
local g = vim.g

g.mapleader = ","

map("n", "r", "<c-r>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<Up>", "<Nop>")
map("n", "<Down>", "<Nop>")
map("n", "<Left>", "<Nop>")
map("n", "<Right>", "<Nop>")

map("n", "Q", "<Nop>")
map("n", "q", "<Nop>")

map("n", "j", "gj")
map("n", "k", "gk")

map("n", "<S-h>", "gT")
map("n", "<S-l>", "gt")

map("n", "<leader>q", "<cmd>q<cr>")
map("n", "<leader>w", "<cmd>w<cr>")

map("n", "<f1>", "<Esc>")
map("i", "<f1>", "<Esc>")

map("i", "<c-c>", "<Esc>")

-- move line
map("n", "<S-j>", "<cmd>m .+1<cr>==")
map("n", "<S-k>", "<cmd>m .-2<cr>==")

-- -- moving cursor to beginning of last row of pasted text
-- map("v", "y", "y`]^")
-- map("v", "p", "p`]^")
-- map("n", "p", "p`]^")

map("n", "Y", "J")

map("n", "<cr>", ":noh<cr>")

-- switch last buffer
map("n", "<leader><leader>", "<c-^>")

map("n", "<f10>", '<cmd>echo "hi:".synIDattr(synID(line("."),col("."),0),"name")<cr>')
