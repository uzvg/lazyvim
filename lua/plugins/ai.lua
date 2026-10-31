-- AI 辅助：opencode.nvim 连接本机 OpenCode（v2）服务。
--
-- 快捷键统一放在 <leader>a 下，与 LazyVim 的 AI extra 命名保持一致：
--   <leader>aa  Ask（输入框，自动带上 @this:）
--   <leader>as  Select（内置 prompt / OpenCode 命令）
--   <leader>ao  Operator（把选区或 motion 发给 OpenCode）
--
-- 仓库：https://github.com/nickjvandyke/opencode.nvim

return {
  {
    "nickjvandyke/opencode.nvim",
    -- main 分支支持 OpenCode v2（本机 `opencode --version` 为 2.x）。
    branch = "main",
    -- 插件通过 plugin/ 下的自动命令转发 OpencodeEvent、处理权限请求和重载文件，
    -- 因此必须在启动时加载。
    lazy = false,
    config = function()
      local opencode = require("opencode")

      vim.keymap.set({ "n", "x" }, "<leader>a", "", { desc = "+ai" })
      vim.keymap.set({ "n", "x" }, "<leader>aa", function()
        opencode.ask("@this: ")
      end, { desc = "Ask OpenCode" })
      vim.keymap.set({ "n", "x" }, "<leader>as", function()
        opencode.select()
      end, { desc = "Select OpenCode prompt/command" })
      vim.keymap.set({ "n", "x" }, "<leader>ao", function()
        return opencode.operator("@this")
      end, { desc = "Send range to OpenCode", expr = true })
    end,
  },
}
