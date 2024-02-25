local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "zig",
    "markdown",
    "markdown_inline",
    "sql",
    "go",
    -- "dotnet",
    "c_sharp",
    "python",
    "json",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}


-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",

    -- c/cpp stuff
    "clangd",
    "clang-format",

    -- sql stuff
    "sqls",

    -- go stuff
    "gopls",

    -- csharp stuff
    "omnisharp",
		"csharpier",

    -- python stuff
    "pyflakes",
    "pycodestyle",

    -- json stuff
    -- "jsonls",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },

  sort = {
    sorter = "case_sensitive",
  },

  view = {
    width = 60,
  },
}

return M
