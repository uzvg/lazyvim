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

-- 输入法联动：进入 Normal 模式时强制西文，回到 Insert 时恢复原来的中英状态。
-- 两者都靠自动命令工作，必须在启动时注册，不能延迟加载；同时只启用一个，
-- 否则会互相覆盖输入法状态。
--
-- 当前系统输入法是 Rime，使用 ibus-rime-remote.nvim；
-- 它调用 PATH 上的 `ibus-rime-remote` 命令（:checkhealth ibus-rime-remote 检查）。
-- 仓库：https://github.com/uzvg/ibus-rime-remote.nvim
--
-- ibus-table-remote.nvim 保留配置但禁用，切回 ibus-table 时改 enabled = true。
-- 它只切换 ibus-table 引擎内部的 Table/Direct 模式，`schema` 取 `ibus engine`
-- 输出里的码表名（形如 table:zhengma → "zhengma"）。
-- 仓库：https://github.com/uzvg/ibus-table-remote.nvim
return {
  {
    "uzvg/ibus-table-remote.nvim",
    enabled = false,
    lazy = false,
    opts = {
      schema = "zhengma",
    },
  },
  {
    "uzvg/ibus-rime-remote.nvim",
    lazy = false,
  },

  -- outline.nvim（LazyVim 的 editor.outline extra）默认 position="right" 会执行
  -- `botright vs`，把 outline 放到整个 tab 的最右边，即 sidekick agent 面板的
  -- 右侧。改成 `belowright vs`：只相对当前（代码）窗口向右拆分，outline 就落在
  -- 编辑器区右缘、agent 面板左侧。position 仍保留 right，用于 h/l 导航方向判断。
  -- 宽度改成固定列数，避免随总列数百分比缩放。
  {
    "hedyhli/outline.nvim",
    opts = {
      outline_window = {
        split_command = "belowright vs",
        position = "right", -- 决定 h/l 导航方向；split_command 非空时不再影响拆分
        relative_width = false,
        width = 30, -- 固定 30 列
      },
    },
  },
}
