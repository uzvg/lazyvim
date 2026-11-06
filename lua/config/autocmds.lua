-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- 背景透明：让 Neovim 不画背景色，露出终端（kitty）自己的背景和透明度。
-- ayu 主题没有 transparent 选项，只能把这些组的背景清成 none（只清 bg，
-- 保留 fg）；绑定 ColorScheme，换主题后仍然生效。本文件在 VeryLazy 才加载，
-- 所以先手动执行一次，否则启动时会闪一下不透明背景。
local function transparent_background()
  for _, name in ipairs({
    "Normal",
    "NormalNC",
    "NormalFloat",
    "SignColumn",
    "FoldColumn",
    "EndOfBuffer",
    "LineNr",
    "CursorLineNr",
    "WinSeparator",
  }) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    hl.bg, hl.ctermbg = nil, nil
    vim.api.nvim_set_hl(0, name, hl)
  end
end

transparent_background()
vim.api.nvim_create_autocmd("ColorScheme", { callback = transparent_background })
