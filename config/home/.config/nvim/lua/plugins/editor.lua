return {
  -- neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", "<cmd>Neotree focus<cr>", desc = "Focus NeoTree", remap = true },
      { "<leader>E", "<cmd>Neotree close<cr>", desc = "Close NeoTree", remap = true },
    },
    opts = {
      window = {
        width = 30,
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
    },
  },
}
