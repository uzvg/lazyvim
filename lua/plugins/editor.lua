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

-- 码表输入法联动：Normal/Visual 模式自动切到 Direct（英文直通），
-- 回到 Insert 时恢复原来的 ibus-table 输入状态。
--
-- 只切换同一个 ibus-table 引擎内部的模式，不切换全局输入法。
-- `schema` 用 `ibus engine` 输出的码表名（形如 table:zhengma → "zhengma"）。
-- 查看状态：:IBusTableRemoteStatus
--
-- 仓库：https://github.com/uzvg/ibus-table-remote.nvim
return {
  {
    "uzvg/ibus-table-remote.nvim",
    -- 通过 ModeChanged 自动命令工作，必须在启动时注册，不能延迟加载。
    lazy = false,
    opts = {
      schema = "zhengma",
    },
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
