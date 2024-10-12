return {
  "hrsh7th/nvim-cmp",

  -- Add border to completion window
  -- Ref:
  --     https://github.com/LazyVim/LazyVim/discussions/4163
  --     https://github.com/hrsh7th/nvim-cmp/blob/ae644feb7b67bf1ce4260c231d1d4300b19c6f30/README.md#recommended-configuration
  opts = function(_, opts)
    local cmp = require("cmp")
    opts.window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    }
  end,
}
