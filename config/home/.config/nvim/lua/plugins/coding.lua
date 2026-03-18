return {

--   TODO: blink.cmp に移行中。安定してそうだったら nvim-cmp の設定を消して良い.
--   -- nvim-cmp
--   {
--     "hrsh7th/nvim-cmp",
--     opts = function(_, opts)
--       local cmp = require("cmp")
--       opts.window = {
--         -- Floating window decoration settings like border and background-color.
--         -- Ref:
--         --     [nvim cmp window ＃2 background and border color - YouTube](https://www.youtube.com/watch?v=PWjEOkGDtTQ)
--         --     [nvim cmp window ＃3 define your own colors - YouTube](https://www.youtube.com/watch?v=wcVcfozoTBM)
--         --     https://github.com/LazyVim/LazyVim/discussions/4163
--         --     https://github.com/hrsh7th/nvim-cmp/blob/ae644feb7b67bf1ce4260c231d1d4300b19c6f30/README.md#recommended-configuration
--
--         -- completion = cmp.config.window.bordered(),
--         -- documentation = cmp.config.window.bordered(),
--
--         -- completion = {
--         --   winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
--         -- },
--         -- documentation = {
--         --   winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
--         -- },
--
--         completion = cmp.config.window.bordered({
--           border = "rounded",
--           winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
--         }),
--         documentation = cmp.config.window.bordered({
--           border = "rounded",
--           winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
--         }),
--       }
--     end,
--   },

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
