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

-- map("n", "<C-Left>", "<cmd>vertical resize -5<cr>", { desc = "Decrease pane width", silent = true })
-- map("n", "<C-Right>", "<cmd>vertical resize +5<cr>", { desc = "Increase pane width", silent = true })
-- map("n", "<C-Up>", "<cmd>resize +5<cr>", { desc = "Increase pane height", silent = true })
-- map("n", "<C-Down>", "<cmd>resize -5<cr>", { desc = "Decrease pane height", silent = true })

-- Resize pane like tmux!!
local function is_at_edge(direction) -- "dierction" = h, j, k, l
  local cur_win = vim.fn.winnr() -- Get the current window number
  vim.cmd("wincmd " .. direction) -- Move to the specified direction
  local new_win = vim.fn.winnr() -- Get the new window number after moving
  local result = cur_win == new_win -- Check if we are still in the same window
  if not result then
    vim.cmd("wincmd p") -- Move back to the original window
  end
  return result
end

local function is_at_left_edge()
  return is_at_edge("h")
end
local function is_at_right_edge()
  return is_at_edge("l")
end
local function is_at_top_edge()
  return is_at_edge("k")
end
local function is_at_bottom_edge()
  return is_at_edge("j")
end
local function resize_window_to_left()
  if is_at_right_edge() then
    if is_at_left_edge() then
      return -- do nothing
    end
    vim.cmd("vertical resize +5")
  else
    vim.cmd("vertical resize -5")
  end
end
local function resize_window_to_right()
  if is_at_right_edge() then
    if is_at_left_edge() then
      return -- do nothing
    end
    vim.cmd("vertical resize -5")
  else
    vim.cmd("vertical resize +5")
  end
end
local function resize_window_to_down()
  if is_at_bottom_edge() then
    if is_at_top_edge() then
      return -- do nothing
    end
    vim.cmd("horizontal resize -5")
  else
    vim.cmd("horizontal resize +5")
  end
end
local function resize_window_to_up()
  if is_at_bottom_edge() then
    if is_at_top_edge() then
      return -- do nothing
    end
    vim.cmd("horizontal resize +5")
  else
    vim.cmd("horizontal resize -5")
  end
end
map("n", "<C-Left>", resize_window_to_left, { desc = "Resize pane to left", silent = true })
map("n", "<C-Right>", resize_window_to_right, { desc = "Resize pane to right", silent = true })
map("n", "<C-Up>", resize_window_to_up, { desc = "Resize pane to up", silent = true })
map("n", "<C-Down>", resize_window_to_down, { desc = "Resize pane to down", silent = true })

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

-- ========= cursor

-- better cursor navigation
-- line navigation
map("n", "<leader>h", "^", { desc = "Jump to first non-black char of line", noremap = true })
map("n", "<leader>l", "$", { desc = "Jump to end of line", noremap = true })
-- paragraph navigation
map("n", "<leader>k", "{", { desc = "Jump to previous paragraph", noremap = true })
map("n", "<leader>j", "}", { desc = "Jump to next paragraph", noremap = true })

-- ========= etc

-- lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })
