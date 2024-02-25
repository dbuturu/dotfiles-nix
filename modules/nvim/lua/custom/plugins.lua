local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
  {
    -- Handle dotnet packages and references
    "JesperLundberg/projektgunnar.nvim",
    dependencies = {
      "echasnovski/mini.pick",
      "echasnovski/mini.notify",
    },
    event = "VeryLazy",
  },

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
    enabled = false,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "stevearc/conform.nvim",
    --  for users those who want auto-save conform + lazyloading!
    -- event = "BufWritePre"
    config = function()
      require "custom.configs.conform"
    end,
  },

  {
    -- Show all todo comments in solution
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end,
    event = "VeryLazy",
  },

  {
    -- File manager
    "echasnovski/mini.files",
    version = false,
    config = function()
      require("core.utils").load_mappings "minifiles"
      require("mini.files").setup {
        mappings = {
          go_in_plus = "<Right>",
          go_out_plus = "<Left>",
          synchronize = "<C-s>",
        },
      }
    end,
    event = "VeryLazy",
  },

  {
    -- Move lines and blocks of code
    "echasnovski/mini.move",
    version = false,
    config = function()
      require("mini.move").setup {
        options = {
          reindent_linewise = true,
        },
      }
    end,
    event = "VeryLazy",
  },

  {
    -- Highlight the word under the cursor
    "echasnovski/mini.cursorword",
    version = false,
    config = function()
      require("mini.cursorword").setup {}
    end,
    event = "BufRead",
  },

  {
    "echasnovski/mini.ai",
    version = false,
    config = function()
      require("mini.ai").setup {}
    end,
    event = "BufRead",
  },

  {
    "github/copilot.vim",
  },

}

return plugins
