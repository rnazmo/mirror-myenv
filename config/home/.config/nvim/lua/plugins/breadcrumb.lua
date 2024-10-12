return {
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
