return {
  -- neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", "<leader>fe", desc = "Toggle NeoTree", remap = true },
      { "<leader>E", "<cmd>Neotree focus<cr>", desc = "Focus NeoTree", remap = true },
    },
    opts = {
      window = {
        width = 30,
      },
      filesystem = {
        filtered_items = {
          -- Show hidden files by default, but allow toggling visibility
          -- Ref: https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/353#discussioncomment-2717085
          visible = true,
          hide_gitignored = true,
          never_show = { ".git", "node_modules" },
        },
      },
    },
  },

  --- outline with aerial.nvim
  {
    "stevearc/aerial.nvim",
    opts = {
      layout = {
        min_width = 28,
        -- default_direction = "right",
        -- placement = "edge",
      },

      -- Place floating window at upper right of current window.
      -- Ref: https://github.com/stevearc/aerial.nvim/issues/107
      float = {
        relative = "win",
        override = function(conf, source_winid) -- <- the source_winid is new
          local padding = 1
          conf.anchor = "NE"
          conf.row = padding
          conf.col = vim.api.nvim_win_get_width(source_winid) - padding
          return conf
        end,
      },
    },
    keys = {
      { "<leader>a", "<cmd>AerialToggle float<cr>", desc = "Toggle Aerial (floating)" },
      { "<leader>A", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial" },
    },
  },

  -- dial.nvim has default config in LazyVim, but somehow it doesn't work.
  -- So explicitly override the key--indings.
  -- Ref:
  --     https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/dial.lua
  --     https://github.com/monaqa/dial.nvim/blob/master/README.md
  {
    "monaqa/dial.nvim",
    keys = {
      {
        "<C-a>",
        function()
          return require("dial.map").inc_normal()
        end,
        expr = true,
        desc = "Increment",
      },
      {
        "<C-x>",
        function()
          return require("dial.map").dec_normal()
        end,
        expr = true,
        desc = "Decrement",
      },
      -- TODO: Add "g<C-a>", "g<C-x>"
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.constant.alias.bool, -- boolean value (true <-> false)
          -- augend.date.alias["%Y-%m-%d"],
          -- Add more augends as needed
        },
      })
    end,
  },
}
