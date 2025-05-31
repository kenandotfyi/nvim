-- GLOBAL VIM OPTIONS

-- always set leader first!
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

vim.opt.colorcolumn = "120"
vim.opt.listchars = { space = "•", tab = ">>", eol = "↵" }
-- let the left and right arrows be useful: they can switch buffers
vim.keymap.set("n", "<left>", ":bp<cr>")
vim.keymap.set("n", "<right>", ":bn<cr>")
-- open new file adjacent to current file
vim.keymap.set("n", "<leader>o", ':e <C-R>=expand("%:p:h") . "/" <cr>')
-- <leader>, shows/hides hidden characters
vim.keymap.set("n", "<leader>h", ":set invlist<cr>")
-- change jk to ESC
vim.keymap.set("i", "jk", "<Esc>")
-- BELOW IS THE PLUGIN CONFIG
-- bootstrap lazy.nvim, LazyVim and your plugins
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "base16-gruvbox-dark-hard",
      },
      import = "lazyvim.plugins",
    },

    -- EOL Inlay Hints
    {
      "chrisgrieser/nvim-lsp-endhints",
      event = "LspAttach",
      opts = {}, -- required, even if empty
    },

    -- indent lines
    {
      "folke/snacks.nvim",
      opts = {
        indent = {
          enabled = true,
          indent = {
            enabled = false,
          },
          chunk = {
            enabled = true,
            char = {
              arrow = ">",
            },
          },
        },
      },
    },
    {
      "ibhagwan/fzf-lua",
      config = function()
        require("fzf-lua").setup({ fzf_colors = true, "ivy" })
      end,
    },
    -- base16 and base24 colorschemes
    -- gallery is here: https://tinted-theming.github.io/tinted-gallery/
    {
      "tinted-theming/tinted-vim",
      lazy = false, -- load at start
      priority = 1000, -- load first
    },

    -- Noice
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = {
        cmdline = {
          view = "cmdline",
        },
      },
    },
    -- modifying lualine
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = function()
        return {
          options = {
            icons_enabled = false,
            theme = "gruvbox_dark",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            always_show_tabline = true,
          },
        }
      end,
    },
    -- main Rust environment plugin
    {
      "mrcjkb/rustaceanvim",
      version = "^6", -- Recommended
      lazy = false, -- This plugin is already lazy
      config = function()
        vim.g.rustaceanvim = {
          tools = {},
          -- LSP configuration
          server = {
            on_attach = function(client, bufnr)
              -- you can also put keymaps in here
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end,
            default_settings = {
              -- rust-analyzer language server configuration
              ["rust-analyzer"] = {
                cargo = {
                  features = "all",
                },
                check = {
                  command = "clippy",
                },
                imports = {
                  group = {
                    enable = false,
                  },
                },
              },
            },
          },
          -- DAP configuration
          dap = {},
        }
      end,
    },
    -- Workaround for Mason problem in LazyVim, will be fixed later. probably.
    { "mason-org/mason.nvim", version = "^1.0.0" },
    { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
    -- treesitter basic configuration
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = {
          "astro",
          "bash",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "yaml",
          "rust",
        },
        indent = {
          disable = {
            "yaml",
          },
        },
      },
    },
    -- go to the root dir of current file
    {
      "notjedi/nvim-rooter.lua",
      config = function()
        require("nvim-rooter").setup()
      end,
    },

    -- delete buffers with mini
    {
      "echasnovski/mini.bufremove",
      keys = {
        {
          "<leader>k",
          function()
            local bd = require("mini.bufremove").delete
            if vim.bo.modified then
              local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
              if choice == 1 then -- Yes
                vim.cmd.write()
                bd(0)
              elseif choice == 2 then -- No
                bd(0, true)
              end
            else
              bd(0)
            end
          end,
          desc = "Delete Buffer",
        },
      },
    },
    -- using <Tab> for completions and snippets
    --
    {
      "saghen/blink.cmp",
      opts = {
        keymap = {
          preset = "default",
          ["<Tab>"] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.accept()
              else
                return cmp.select_and_accept()
              end
            end,
            "snippet_forward",
            "fallback",
          },
        },
      },
    },

    {
      "stevearc/conform.nvim",
      opts = {
        formatters_by_ft = {
          yaml = { "yamlfmt" },
        },
      },
    },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = {},
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = true, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- making the hovered texts underlined, instead of getting a different color for better readability

vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true })

-- RUST RELATED
-- Adding Rust related keybindings to rustaceanvim with whichkey
vim.api.nvim_create_augroup("RustKeybindings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "RustKeybindings",
  pattern = "rust",
  callback = function()
    local opts = { buffer = true, noremap = true, silent = true }

    -- Hover actions
    vim.keymap.set(
      "n",
      "<leader>rh",
      "<cmd>RustLsp hover actions<CR>",
      vim.tbl_extend("force", opts, { desc = "Hover Actions" })
    )

    -- Code actions
    vim.keymap.set(
      "n",
      "<leader>ra",
      "<cmd>RustLsp codeAction<CR>",
      vim.tbl_extend("force", opts, { desc = "Code Action" })
    )

    -- Expand macro
    vim.keymap.set(
      "n",
      "<leader>rem",
      "<cmd>RustLsp expandMacro<CR>",
      vim.tbl_extend("force", opts, { desc = "Expand Macro" })
    )

    -- Open Cargo.toml
    vim.keymap.set(
      "n",
      "<leader>rct",
      "<cmd>RustLsp openCargo<CR>",
      vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" })
    )

    -- Toggle inlay hints
    vim.keymap.set(
      "n",
      "<leader>rih",
      "<cmd>RustLsp inlayHints<CR>",
      vim.tbl_extend("force", opts, { desc = "Toggle Inlay Hints" })
    )
  end,
})

-- jump to last edit position on opening file
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function(ev)
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      -- except for in git commit messages
      -- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
      if not vim.fn.expand("%:p"):find(".git", 1, true) then
        vim.cmd('exe "normal! g\'\\""')
      end
    end
  end,
})

-- automatically remove the hidden characters at buf enter
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*",
  callback = function(ev)
    vim.opt.list = false
  end,
})

-- showing the cwd in tmux window names
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  callback = function()
    local cwd = vim.fn.getcwd()
    local pane = vim.fn.getenv("TMUX_PANE")

    vim.notify("cwd: " .. cwd, vim.log.levels.INFO)
    vim.notify("pane: " .. vim.inspect(pane), vim.log.levels.INFO)

    if pane and pane ~= "" then
      local path = vim.fn.expand("~/.config/tmux/nvim_cwd_" .. pane)
      local ok, err = pcall(function()
        local file = io.open(path, "w")
        if file then
          file:write(cwd)
          file:close()
        else
          vim.notify("❌ Could not open file for writing", vim.log.levels.ERROR)
        end
      end)

      if not ok then
        vim.notify("❌ Write error: " .. err, vim.log.levels.ERROR)
      else
        vim.notify("✅ Successfully wrote to " .. path, vim.log.levels.INFO)
      end
    else
      vim.notify("❌ TMUX_PANE not set", vim.log.levels.WARN)
    end
  end,
})
