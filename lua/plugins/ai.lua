-- AI 辅助：opencode.nvim 连接本机 OpenCode（v2）服务。
--
-- 快捷键统一放在 <leader>a 下，与 LazyVim 的 AI extra 命名保持一致：
--   <leader>aa  Ask（输入框，自动带上 @this:）
--   <leader>as  Select（内置 prompt / OpenCode 命令）
--   <leader>ao  Operator（把选区或 motion 发给 OpenCode）
--   <leader>at  Toggle OpenCode TUI
--
-- 与 LazyVim 组件的配合：
--   snacks.terminal  没有服务时在右侧分屏启动 opencode TUI
--   snacks.picker    Select 菜单；在 picker 里按 <a-o> 可把选中项发给 OpenCode
--
-- 仓库：https://github.com/nickjvandyke/opencode.nvim

local opencode_cmd = "opencode"

---@type snacks.terminal.Opts
local terminal_opts = {
  win = {
    position = "right",
    -- 启动后把焦点留在原窗口，避免打断编辑。
    enter = false,
  },
}

return {
  {
    "nickjvandyke/opencode.nvim",
    -- main 分支支持 OpenCode v2（本机 `opencode --version` 为 2.x）。
    branch = "main",
    -- 插件通过 plugin/ 下的自动命令转发 OpencodeEvent、处理权限请求和重载文件，
    -- 因此必须在启动时加载。
    lazy = false,
    init = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          -- 没有检测到正在运行的 OpenCode 服务时，用 Snacks 终端启动一个。
          -- opencode v2 会自动注册后台服务，插件随后会连上它。
          start = function()
            require("snacks.terminal").open(opencode_cmd, terminal_opts)
          end,
        },
      }
    end,
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
      vim.keymap.set("n", "<leader>at", function()
        require("snacks.terminal").toggle(opencode_cmd, terminal_opts)
      end, { desc = "Toggle OpenCode" })
      -- 终端模式不要用 <leader> 前缀，否则在 TUI 里输入空格会等待 timeout。
      vim.keymap.set("t", "<C-.>", function()
        require("snacks.terminal").toggle(opencode_cmd, terminal_opts)
      end, { desc = "Toggle OpenCode" })
    end,
  },

  -- opencode.nvim 的 Ask 输入框使用 snacks.input，并启动一个进程内 LSP
  -- 来补全 @this/@buffer 等上下文。这里为 opencode_ask 文件类型显式打开
  -- blink.cmp 的 lsp/buffer 来源。
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        per_filetype = {
          opencode_ask = { "lsp", "buffer" },
        },
      },
    },
  },

  -- 在 LazyVim 的 lualine 右端显示 OpenCode 服务连接状态。
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_z = opts.sections.lualine_z or {}
      table.insert(opts.sections.lualine_z, 1, {
        function()
          return require("opencode").statusline()
        end,
        cond = function()
          return package.loaded["opencode"] ~= nil
        end,
      })
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        actions = {
          ---把 picker 中选中的文件/位置格式化成 OpenCode 能理解的引用。
          ---@param picker snacks.Picker
          opencode_send = function(picker)
            local items = vim.tbl_map(function(item) ---@param item snacks.picker.Item
              return item.file and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
                or item.text
            end, picker:selected({ fallback = true }))

            require("opencode").prompt(table.concat(items, ", ") .. " ")
          end,
        },
        win = {
          input = {
            keys = {
              ["<a-o>"] = { "opencode_send", mode = { "n", "i" }, desc = "Send to OpenCode" },
            },
          },
        },
      },
    },
  },
}
