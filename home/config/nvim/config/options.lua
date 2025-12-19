-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- UI Polish and Readability
opt.cursorline = true -- Highlight the current line
opt.cursorlineopt = "both" -- Highlight both line number and text
opt.pumblend = 10 -- Popup menu transparency
opt.winblend = 10 -- Floating window transparency

-- Better visual feedback
opt.termguicolors = true -- True color support
opt.showmode = false -- Don't show mode (already in statusline)
opt.signcolumn = "yes" -- Always show signcolumn

-- Smooth scrolling
opt.smoothscroll = true -- Enable smooth scrolling

-- Better search highlighting
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Incremental search

-- Window focus indicators (works with focus.nvim)
opt.winhl = "Normal:Normal,NormalNC:NormalNC" -- Different highlight for inactive windows

-- Better completion menu
opt.completeopt = "menu,menuone,noselect"

-- Borders for floating windows
vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})

-- Make hover windows have borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})
