-- 编辑增强：文本对象、环绕、自动配对、注释、treesitter 等。
-- 新增插件时，直接追加到下面的 return 列表中。
--
-- 示例：
-- {
--   "kylechui/nvim-surround",
--   version = "*",
--   event = "VeryLazy",
-- },
--
-- 追加 treesitter 解析器（LazyVim 已默认安装常用解析器）：
-- {
--   "nvim-treesitter/nvim-treesitter",
--   opts_extend = { "ensure_installed" },
--   opts = { ensure_installed = { "dockerfile", "gitignore" } },
-- },

return {}
