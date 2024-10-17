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

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- Remove the time info (= luzline_z) from lualine
      opts.sections.lualine_z = {}
      return opts
    end,
  },

  --- outline
  {
    "hedyhli/outline.nvim",
    opts = {
      outline_window = {
        width = 15,
        auto_close = true,
      },
    },
    keys = { { "<leader>o", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
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

  -- breadcrumb
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>p",
        function()
          require("dropbar.api").pick()
        end,
        desc = "Select breadcrumb",
      },
    },
    -- optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = {
      general = {
        update_interval = 100,
      },
    },
  },
}
