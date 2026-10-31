-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 系统剪贴板按需使用。
-- options.lua 里 clipboard 为空，因此 d/x/s/c/p 等操作只读写 Neovim 内部寄存器，
-- 不会触发系统剪贴板。需要与系统剪贴板交互时，显式使用下面的快捷键；
-- 想删除且不写任何寄存器，使用 `"_d`（黑洞寄存器）。
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

-- 复制到系统剪贴板
map({ "n", "x" }, "<leader>y", '"+y', "Yank to system clipboard")
map("n", "<leader>Y", '"+Y', "Yank line to system clipboard")

-- 从系统剪贴板粘贴
map("n", "<leader>p", '"+p', "Paste from system clipboard")
map("n", "<leader>P", '"+P', "Paste from system clipboard before cursor")
-- 可视模式：先把选区丢进黑洞寄存器，再粘贴系统剪贴板，避免覆盖匿名寄存器
map("x", "<leader>p", '"_d"+P', "Paste from system clipboard (keep registers)")
