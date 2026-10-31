-- LSP、Mason、格式化与 lint 的覆盖配置。
--
-- 语言支持优先用 :LazyExtras 启用，例如 lang.python 已提供 pyright + ruff，
-- lang.typescript 已提供 vtsls/ts_ls，不需要手动往 lspconfig 里塞 server。
--
-- 追加 LSP server 示例：
-- { "neovim/nvim-lspconfig", opts = { servers = { pyright = {} } } },
--
-- 追加 Mason 工具示例（stylua、shfmt 默认已安装）：
-- {
--   "mason-org/mason.nvim",
--   opts_extend = { "ensure_installed" },
--   opts = { ensure_installed = { "shellcheck" } },
-- },

return {}
