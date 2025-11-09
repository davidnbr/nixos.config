-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Buffer Management
-- Smart quit (close buffer first, then vim if last buffer)
keymap.set("n", "<leader>q", "<cmd>SmartQuit<cr>", { desc = "Smart quit (close buffer or vim)" })

-- Close current buffer
keymap.set("n", "<leader>bd", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer" })

-- Close all buffers except current
keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Delete other buffers" })

-- Close all buffers to the right
keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Delete buffers to the right" })

-- Close all buffers to the left
keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Delete buffers to the left" })

-- Navigate between buffers
keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })

-- Pin/unpin buffer
keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Toggle buffer pin" })

-- Window Navigation Enhancement
-- Focus on window management
keymap.set("n", "<leader>wf", "<cmd>FocusToggle<cr>", { desc = "Toggle focus mode" })
keymap.set("n", "<leader>wm", "<cmd>FocusMaximise<cr>", { desc = "Maximize current window" })
keymap.set("n", "<leader>we", "<cmd>FocusEqualise<cr>", { desc = "Equalize windows" })

-- Better window navigation (keep default LazyVim bindings but add alternatives)
keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Go to left window" })
keymap.set("n", "<C-Down>", "<C-w>j", { desc = "Go to lower window" })
keymap.set("n", "<C-Up>", "<C-w>k", { desc = "Go to upper window" })
keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Go to right window" })

-- Clear search highlighting
keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlighting" })

-- Better visual indenting (keep selection after indent)
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)
