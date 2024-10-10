-- Ref:
--     https://www.lazyvim.org/plugins/colorscheme
--     https://stackoverflow.com/a/77159562
--     https://github.com/LazyVim/LazyVim/discussions/3012
return {
    -- Add a colorscheme
    -- { "ellisonleaoz/gruvbox.nvim" },
    -- { "gbprod/nord.nvim" },
    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = { style = "night" },
    },

    -- Configure LazyVim to load the colorscheme
    {
      "LazyVim/LazyVim",
      opts = {
        -- co/lorscheme = "gruvbox",
        -- colorscheme = "nord",
        colorscheme = "tokyonight",
      },
    }
}
