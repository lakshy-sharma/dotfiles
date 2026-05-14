-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
--
--

local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.scrolloff = 8
opt.clipboard = "unnamedplus"
opt.timeoutlen = 300
opt.wrap = false

vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	update_in_insert = false,
})
