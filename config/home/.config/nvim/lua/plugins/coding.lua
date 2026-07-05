return {

  -- blink.cmp
  {
      "saghen/blink.cmp",
      opts = {
          completion = {
              menu = { border = "rounded" },
              documentation = { window = { border = "rounded" } },
          },
      },
  },

  -- multi cursor
  {
    "mg979/vim-visual-multi",
    lazy = false,
    -- event = "VeryLazy",
  },
}
