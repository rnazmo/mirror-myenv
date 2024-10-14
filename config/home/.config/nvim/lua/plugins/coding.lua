return {

  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- local cmp = require("cmp")
      opts.window = {
        -- Floating window decoration settings like border and background-color.
        -- Ref:
        --     [nvim cmp window ＃2 background and border color - YouTube](https://www.youtube.com/watch?v=PWjEOkGDtTQ)
        --     https://github.com/LazyVim/LazyVim/discussions/4163
        --     https://github.com/hrsh7th/nvim-cmp/blob/ae644feb7b67bf1ce4260c231d1d4300b19c6f30/README.md#recommended-configuration

        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),

        completion = {
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
        },

        -- completion = cmp.config.window.bordered({
        --   border = "rounded",
        --   winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
        -- }),
        -- documentation = cmp.config.window.bordered({
        --   border = "rounded",
        --   winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
        -- }),
      }
    end,
  },

  -- multi cursor
  {
    "mg979/vim-visual-multi",
    lazy = false,
    -- event = "VeryLazy",
  },
}
