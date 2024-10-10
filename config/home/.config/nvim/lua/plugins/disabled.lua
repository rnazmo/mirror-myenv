-- Disable some LazyVim default plugins
-- Ref:
--     https://www.lazyvim.org/configuration/plugins
return {
    -- -- Example:
    -- { "folke/trouble.nvim", enabled = false },
    
    -- UI

    -- Disable notify
    -- Ref: https://www.lazyvim.org/plugins/ui#nvim-notify
    { "rcarriga/nvim-notify", enabled = false },

    -- Disable noice
    -- Ref: https://www.lazyvim.org/plugins/ui#noicenvim
    { "folke/noice.nvim", enabled = false },
}
