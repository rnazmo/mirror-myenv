return {
  -- Disable notify
  -- Ref: https://www.lazyvim.org/plugins/ui#nvim-notify
  { "rcarriga/nvim-notify", enabled = false },

  -- Disable noice
  -- Ref: https://www.lazyvim.org/plugins/ui#noicenvim
  { "folke/noice.nvim", enabled = false },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        -- Buffers are hard to manage, so I don't use them.
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,

        always_show_bufferline = true,
      },
    },
  },

  -- statusline & window bar
  -- Ref:
  --     https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/ui.lua#L96
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      -- TODO: Improve statusline (Display buffer?, ...)
      sections = {
        -- Remove the time info (= luzline_z) from lualine
        lualine_z = {},
      },
      -- Display winbar (window bar) with lualine
      winbar = {
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          -- Use pretty *full* path
          --     pretty_path truncates path to 3 directories or ress by default.
          --     I want to display full path (from the project root).
          -- Ref:
          --     TODO:
          --     https://github.com/LazyVim/LazyVim/issues/3059
          --     https://github.com/LazyVim/LazyVim/issues/2752
          --     https://github.com/LazyVim/LazyVim/blob/13a4a84e3485a36e64055365665a45dc82b6bf71/lua/lazyvim/util/lualine.lua#L76
          { LazyVim.lualine.pretty_path({ length = 0 }) },
        },
      },
      inactive_winbar = {
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { LazyVim.lualine.pretty_path({ length = 0 }) },
        },
      },
    },
  },

  --- outline
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
      { "<leader>o", "<cmd>AerialToggle float<cr>", desc = "Toggle Aerial (floating)" },
      { "<leader>O", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial" },
    },
  },

  -- {
  --   "hedyhli/outline.nvim",
  --   opts = {
  --     outline_window = {
  --       width = 15,
  --       auto_close = true,
  --     },
  --   },
  --   keys = { { "<leader>o", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
  -- },

  -- twilight
  {
    "folke/twilight.nvim",
    opts = {
      dimming = { alpha = 0.30 },
    },
    keys = { { "<leader>ct", "<cmd>Twilight<cr>", desc = "Toggle Twilight" } },
  },

  -- zenmode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = { backdrop = 0.7 },
      plugins = {
        gitsigns = true,
        tmux = true,
        alacritty = { enabled = false },
      },
    },
    keys = {
      { "<C-w>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    },
  },

  -- -- breadcrumb
  -- {
  --   "Bekaboo/dropbar.nvim",
  --   event = "VeryLazy",
  --   keys = {
  --     {
  --       "<leader>p",
  --       function()
  --         require("dropbar.api").pick()
  --       end,
  --       desc = "Select breadcrumb",
  --     },
  --   },
  --   -- optional, but required for fuzzy finder support
  --   dependencies = {
  --     "nvim-telescope/telescope-fzf-native.nvim",
  --   },
  --   config = {
  --     general = {
  --       update_interval = 100,
  --     },
  --   },
  -- },
}
