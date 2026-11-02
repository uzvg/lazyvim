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

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      -- lang.markdown extra 默认给 markdown 挂了 markdownlint-cli2，
      -- 这里移除，避免 MD013 等默认规则在打开/保存时刷诊断。
      -- 必须用 nil 删除：lazy.nvim 深合并时 markdown = {} 不会覆盖已有列表。
      -- markdown.mdx 会按 "." 拆分 filetype，同样复用 markdown 的配置。
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = nil
      return opts
    end,
  },
  {
    -- 同理：conform 的 markdownlint 只在存在 source=="markdownlint" 的诊断时才运行，
    -- nvim-lint 的 markdown 诊断已在上面的配置里移除，这条格式化链路永远不会触发。
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        markdown = { "prettier", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdown-toc" },
      },
    },
  },
  {
    -- extra 仍会把 markdownlint-cli2 加进 ensure_installed（opts_extend 会追加列表，无法覆盖），
    -- 所以用 opts 函数在合并后过滤掉。
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "markdownlint-cli2"
      end, opts.ensure_installed or {})
    end,
  },
}
