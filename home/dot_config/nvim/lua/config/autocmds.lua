-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- 起動時にファイルツリー (snacks explorer) を自動表示する (ダッシュボード起動時も含む)
-- このファイルは VeryLazy (VimEnter より後) に読み込まれるため、autocmd ではなく直接実行する
-- ディレクトリ指定で起動した場合は snacks が explorer を開くので除外
local is_dir_launch = vim.fn.argc(-1) > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
if #vim.api.nvim_list_uis() > 0 and not is_dir_launch then
  Snacks.explorer()
  vim.schedule(function()
    vim.cmd.wincmd("p")
  end)
end
