return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    -- Remove the time info from lualine_z
    opts.sections.lualine_z = {}
    return opts
  end,
}
