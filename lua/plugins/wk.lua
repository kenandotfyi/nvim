return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    defaults = {
      mode = { "n", "v" },
    },
  },
  config = function(_)
    local wk = require("which-key")
    wk.register({
      ["<leader>f"] = {
        name = "+file",
        s = { "<cmd>w<cr>", "Save file" },
      },
      ["<leader><tab>"] = { name = "+tabs" },
      ["<leader>b"] = {
        name = "+buffer",
        s = { "<cmd>BufferLinePick<CR>", "Buffer Line Pick" },
      },
      ["<leader>c"] = { name = "+code" },
      ["<leader>g"] = { name = "+git" },
      ["<leader>gh"] = { name = "+hunks" },
      ["<leader>q"] = { name = "+quit/session" },
      ["<leader>s"] = { name = "+search" },
      ["<leader>u"] = { name = "+ui" },
      ["<leader>w"] = { name = "+windows" },
      ["<leader>x"] = { name = "+diagnostics/quickfix" },
      ["g"] = { name = "+goto" },
      ["gs"] = { name = "+surround" },
      ["z"] = { name = "+fold" },
      ["]"] = { name = "+next" },
      ["["] = { name = "+prev" },
    })
  end,
}
