-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function copy_path(modifier, label)
  return function()
    local path = vim.fn.expand("%" .. modifier)
    vim.fn.setreg("+", path)
    vim.notify(label .. "をコピー: " .. path)
  end
end

vim.keymap.set("n", "<leader>fy", copy_path("", "相対パス"), { desc = "相対パスをコピー" })
vim.keymap.set("n", "<leader>fY", copy_path(":p", "絶対パス"), { desc = "絶対パスをコピー" })
