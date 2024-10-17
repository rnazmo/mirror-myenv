return {
  -- neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", "<leader>fe", desc = "Toggle NeoTree", remap = true },
      { "<leader>E", "<cmd>Neotree focus<cr>", desc = "Focus NeoTree", remap = true },
    },
    opts = {
      window = {
        width = 30,
      },
      filesystem = {
        filtered_items = {
          -- Show hidden files by default, but allow toggling visibility
          -- Ref: https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/353#discussioncomment-2717085
          visible = true,
          hide_gitignored = true,
          never_show = { ".git", "node_modules" },
        },
      },
    },
  },
}
