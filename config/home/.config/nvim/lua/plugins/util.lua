return {
  {
    "folke/persistence.nvim",
    keys = {
      {
        "<C-w><A-u>",
        function()
          require("persistence").select()
        end,
        desc = "Select Session",
      },
    },
  },
}
