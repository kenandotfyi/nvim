-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- dire and file name over top right
vim.opt.winbar = "%=%m %f"
vim.opt.undofile = true
vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.wrap = true
vim.opt.scrolloff = 10
vim.opt.textwidth = 0
vim.opt.wrapmargin = 5

vim.opt.guicursor = {
  "n-v-c:block", -- Normal, visual, command-line: block cursor
  "i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
  "r-cr:hor20", -- Replace, command-line replace: horizontal bar cursor with 20% height
  "o:hor50", -- Operator-pending: horizontal bar cursor with 50% height
  "a:blinkwait700-blinkoff400-blinkon250", -- All modes: blinking settings
  "sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch: block cursor with specific blinking settings
}
