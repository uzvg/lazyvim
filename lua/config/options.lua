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

-- 让拼写检查放过中文。
-- LazyVim 会对 markdown/text/typst/gitcommit 等 FileType 打开 spell，且默认
-- spelllang={"en"}；Neovim 的拼写引擎不支持中日韩文字，CJK 字符默认全部被
-- 当成拼写错误（红波浪线）。"cjk" 是内置的伪语言，加入后 CJK 不再算错，
-- 英文拼写检查仍然有效，也不需要额外下载 .spl 文件。
vim.opt.spelllang = { "en", "cjk" }

-- Python 类型检查使用 basedpyright（ruff 继续负责 lint + format）。
-- 必须在 LazyVim 加载 lang.python extra 之前设置，因此放 options.lua。
vim.g.lazyvim_python_lsp = "basedpyright"
