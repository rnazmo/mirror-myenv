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
    enabled = false,
    -- opts = {
    --   options = {
    --     separator_style = "slope",
    --     -- Buffers are hard to manage, so I don't use them.
    --     mode = "tabs",
    --     show_buffer_close_icons = false,
    --     show_close_icon = false,
    --
    --     always_show_bufferline = true,
    --   },
    -- },
  },

  -- statusline & tabline & window bar
  -- Ref:
  --     https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/ui.lua#L96
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      -- statusline
      -- TODO: Improve statusline (Display buffer?, ...)
      sections = {
        -- Remove the time info (= luzline_z) from lualine
        lualine_z = {},
      },

      -- tabline
      tabline = {
        lualine_a = { "tabs" },
      },

      -- winbar (window bar)
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
}
