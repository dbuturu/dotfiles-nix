---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },

    --  format with conform
    ["<leader>fm"] = {
      function()
        require("conform").format()
      end,
      "formatting",
    },

  },
  v = {
    [">"] = { ">gv", "indent"},
  },
}

-- Switch tabs with Alt+1..9
for i = 1, 9, 1 do
  vim.keymap.set("n", string.format("<A-%s>", i), function()
    vim.api.nvim_set_current_buf(vim.t.bufs[i])
  end)
end

-- more keybinds!

M.projektgunnar = {
  n = {
    ["<leader>pap"] = { "<cmd>AddNugetToProject<cr>", "Add packages to project" },
    ["<leader>par"] = { "<cmd>AddProjectToProject<cr>", "Add project reference to other project" },
    ["<leader>pup"] = { "<cmd>UpdateNugetsInProject<cr>", "Update packages in project" },
    ["<leader>pus"] = { "<cmd>UpdateNugetsInSolution<cr>", "Update packages in solution" },
  },
}

M.minifiles = {
  plugin = true,

  n = {
    ["<C-n>"] = {
      function()
        require("mini.files").open()
      end,
      "open file browser",
    },
    -- find the mappings in the setup of the plugin in plugins.lua
  },
}

M.minimove = {
  n = {
    ["<A-Left>"] = {
      function()
        require("mini.move").move_line "left"
      end,
      "move line left",
    },
    ["<A-Right>"] = {
      function()
        require("mini.move").move_line "right"
      end,
      "move line right",
    },
    ["<A-Down>"] = {
      function()
        require("mini.move").move_line "down"
      end,
      "move line down",
    },
    ["<A-Up>"] = {
      function()
        require("mini.move").move_line "up"
      end,
      "move line up",
    },
  },
  v = {
    ["<A-Left>"] = {
      function()
        require("mini.move").move_selection "left"
      end,
      "move selection left",
    },
    ["<A-Right>"] = {
      function()
        require("mini.move").move_selection "right"
      end,
      "move selection right",
    },
    ["<A-Down>"] = {
      function()
        require("mini.move").move_selection "down"
      end,
      "move selection down",
    },
    ["<A-Up>"] = {
      function()
        require("mini.move").move_selection "up"
      end,
      "move selection up",
    },
  },
}

return M
