-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
---------------------------------------------------------------------
--- Info:
---     About `vim.map()`
---         TODO:
---     Defference between `map` and `noremap`
---         TODO:
---         Ref: https://cocopon.me/blog/2013/10/vim-map-noremap/
---
--- Ref:
---     https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
---     https://www.josean.com/posts/how-to-setup-neovim-2024
---     https://neovim.io/doc/user/map.html#_1.10-mapping-alt-keys
---

-- for conciseness
local del = vim.keymap.del
local map = vim.keymap.set

-- ======================================================
-- ======== Reset                                       =
-- ======================================================

-- Disable some LazyVim keybindings
-- Ref:
--     https://www.lazyvim.org/configuration/keymaps
--     https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
del("n", "<leader>-")
del("n", "<leader>|")
del("n", "<leader>wd")

-- ======================================================
-- ======== Add                                         =
-- ======================================================

-- ========= pane

-- `<C-w>h`: default
-- `<C-w>j`: default
-- `<C-w>k`: default
-- `<C-w>l`: default
map("n", "<C-h>", "<C-w>h", { desc = "Go to left pane", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower pane", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper pane", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right pane", remap = true })

map("n", "<C-w>g", "<cmd>vnew<CR>", { desc = "New black pane", silent = true })

map("n", "<C-w>;", "<cmd>vsplit<CR>", { desc = "New virtical pane", silent = true })
map("n", "<C-w>'", "<cmd>split<CR>", { desc = "New horizontal pane", silent = true })

-- `<C-w>q`: default

-- `<C-w>o`: default

-- `<C-w>/`: default

-- Resize pane like tmux
--
--     tmux の挙動の再現。
--     tmux の挙動について：
--         左右：そのウィンドウが右端なら、そのウィンドウの左側の枠が動き、
--             そのウィンドウが右端以外なら、そのウィンドウの右側の枠が動く。
--         上下：そのウィンドウが下端なら、そのウィンドウの上側の枠が動き、
--             そのウィンドウが下端以外なら、そのウィンドウの上側の枠が動く。
--     NOTE:
--        edgy.nvim と一緒に使うと、端検知周りでかなりバグる
--            => edgy.nvim は使わない
--        aerial.nvim と一緒に使うと、軽くバグる
--            => どうしよう。バグが軽微で、あまり問題無いのでとりあえこのままで
--
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

-- TODO: swap pane with previous/next?
-- This is not the behaviour I expected.
-- map("n", "<C-w>f", "<cmd>wincmd x<CR>", { desc = "Swap pane with next??" })

map("n", "<C-w>b", "<C-w>T", { desc = "Break pane to new tab", noremap = true })
-- TODO: break pane to previous/next tab

-- ========= tabpage

map("n", "<C-w><C-h>", "<cmd>tabp<CR>", { desc = "Go to previous tab", silent = true })
map("n", "<C-w><C-l>", "<cmd>tabn<CR>", { desc = "Go to next tab", silent = true })
-- TODO: Go to first/last tab
map("n", "<C-w><C-g>", "<cmd>tabnew<CR>", { desc = "New tab", silent = true })
map("n", "<C-w><C-q>", "<cmd>tabclose<CR>", { desc = "Close tab", silent = true })
map("n", "<C-w><C-o>", "<cmd>tabonly<CR>", { desc = "Close other tabs", silent = true })

-- TODO: swap tab with previous/next?

-- ========= session

map("n", "<C-w><A-q>", "<cmd>qa<CR>", { desc = "Close session" })

-- ========= server
-- ?

-- ========= cursor

-- better cursor navigation
-- line navigation
map("n", "<leader>h", "^", { desc = "Jump to first non-black char of line" })
map("n", "<leader>l", "$", { desc = "Jump to end of line" })
-- paragraph navigation
map("n", "<leader>k", "{", { desc = "Jump to previous paragraph" })
map("n", "<leader>j", "}", { desc = "Jump to next paragraph" })

-- ========= etc
-- Apply unified diff from X11 clipboard to current file
-- (uses my custom script "~/.bin/applypatch" which auto-detects -p0/-p1)
map("n", "<leader>P", ":!applypatch %<CR>", { desc = "Apply clipboard patch to current file", silent = false })

-- lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })
