return {
  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("codeium").setup({
      -- To use codeium chat with `:Codeium Chat` command.
      -- Ref: https://github.com/Exafunction/codeium.nvim/blob/17bbefff02be8fd66931f366bd4ed76a76e4a57e/README.md#usage
      enable_chat = true,
    })
  end,
}
