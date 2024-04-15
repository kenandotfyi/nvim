-- Keymaps are automatically loaded on the VeryLazy event
-- Add any additional keymaps here
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Open Oil
vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open parent dir-Oil" })
vim.keymap.set("i", "jk", "<Esc>")
