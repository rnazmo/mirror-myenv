-- Ref:
--     https://www.lazyvim.org/plugins/colorscheme
--     https://stackoverflow.com/a/77159562
--     https://github.com/LazyVim/LazyVim/discussions/3012
return {

  -- Disable the colorscheme
  -- Ref: https://www.lazyvim.org/plugins/colorscheme
  { "catppuccin/nvim", enabled = false },

  -- Add a colorscheme
  -- { "ellisonleaoz/gruvbox.nvim" },
  -- { "gbprod/nord.nvim" },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night",
      -- style = "storm",
      -- style = "moon",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_colors = function(colors)
        colors.border = "#565f89"
      end,
    },
  },

  -- Configure LazyVim to load the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "gruvbox",
      -- colorscheme = "nord",
      colorscheme = "tokyonight",
    },
  },
}
