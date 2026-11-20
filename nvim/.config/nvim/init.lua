-- init.lua — minimal, sane Neovim starter. Grow from here.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ---- Options --------------------------------------------------------------
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- share system clipboard
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.undofile = true -- persistent undo
opt.wrap = false

-- ---- Keymaps --------------------------------------------------------------
local map = vim.keymap.set
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- ---- Plugins --------------------------------------------------------------
-- Ready to grow: install lazy.nvim (https://lazy.folke.io) and add a spec here.
