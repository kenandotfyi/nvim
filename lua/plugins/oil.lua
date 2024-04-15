return {
  "stevearc/oil.nvim",
  opts = {
    columns = {
      "icon",
      "mtime",
    },
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 4,
      max_width = 600,
      max_height = 600,
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
