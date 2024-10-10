-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
---------------------------------------------------------------------
--- Info:
---     About `vim.map()`
---         TODO:
--- Ref:
---     https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
---     https://www.josean.com/posts/how-to-setup-neovim-2024
---     https://neovim.io/doc/user/map.html#_1.10-mapping-alt-keys
---

local map = vim.keymap.set -- for conciseness

-- ========= pane

map("n", "<C-h>", "<C-w>h", { desc = "Go to left pane", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower pane", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper pane", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right pane", remap = true })

map("n", "<C-w>;", "<cmd>vsplit<CR>", { desc = "New virtical pane", silent = true })
map("n", "<C-w>'", "<cmd>split<CR>", { desc = "New horizontal pane", silent = true })

-- map("n", "<C-w><C-Up>", "<cmd>resize +2<cr>", { desc = "Increase pane height", silent = true })
-- map("n", "<C-w><C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease pane height", silent = true })
-- map("n", "<C-w><C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease pane width", silent = true })
-- map("n", "<C-w><C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase pane width", silent = true })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase pane height", silent = true })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease pane height", silent = true })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease pane width", silent = true })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase pane width", silent = true })

-- ========= tabpage

map("n", "<C-w>H", "<cmd>tabp<CR>", { desc = "Go to previous tab", silent = true })
map("n", "<C-w>L", "<cmd>tabn<CR>", { desc = "Go to next tab", silent = true })
map("n", "<C-w><C-h>", "<cmd>tabp<CR>", { desc = "Go to previous tab", silent = true })
map("n", "<C-w><C-l>", "<cmd>tabn<CR>", { desc = "Go to next tab", silent = true })
map("n", "<C-w>C", "<cmd>tabnew<CR>", { desc = "New tab", silent = true })
map("n", "<C-w>Q", "<cmd>tabclose<CR>", { desc = "Close tab", silent = true })

-- use jk to exit insert mode
-- map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- map("n", "<ESC><ESC>", ":noh<CR>", { desc = "Clear search highlights", silent = true })
