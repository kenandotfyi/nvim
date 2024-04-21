return {
  "simrat39/rust-tools.nvim",
  config = function(_)
    local rt = require("rust-tools")
    rt.setup({
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>rh", rt.hover_actions.hover_actions, { buffer = bufnr })
          vim.keymap.set("n", "<leader>ra", rt.code_action_group.code_action_group, { buffer = bufnr })
        end,
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
      },
    })
  end,
}
