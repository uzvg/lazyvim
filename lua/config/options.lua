-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 默认不让匿名寄存器与系统剪贴板同步。
-- LazyVim 默认把 clipboard 设为 "unnamedplus"，这会让 x/s/d/c/p 等日常操作
-- 每次都读写系统剪贴板（Wayland 下会反复调用 wl-copy/wl-paste，既污染系统
-- 剪贴板，也可能带来卡顿）。需要与系统剪贴板交互时，显式使用
-- keymaps.lua 里的 <leader>y / <leader>p。
--
-- 必须写在用户 options.lua 中，才能覆盖 LazyVim 的默认值；LazyVim 会在
-- VeryLazy 时恢复此处读到的值，所以启动后 clipboard 仍然为空。
vim.opt.clipboard = ""
