# LazyVim 配置结构与插件管理笔记

> 适用配置：`~/.config/lazyvim`（LazyVim starter 模板）
> 启动方式：`NVIM_APPNAME=lazyvim nvim`
> 最后整理：2026-10-31

---

## 1. 目录结构

```text
~/.config/lazyvim/
├── init.lua                  # 入口，只做一件事：require("config.lazy")
├── lua/
│   ├── config/               # 启动配置（框架层）
│   │   ├── lazy.lua          # 引导 lazy.nvim + 加载 LazyVim + 加载插件
│   │   ├── options.lua       # vim.opt 选项
│   │   ├── keymaps.lua       # 自定义快捷键
│   │   └── autocmds.lua      # 自定义自动命令
│   └── plugins/              # 插件配置（业务层，重点）
│       └── example.lua       # 官方示例，被首行 guard 禁用
├── lazyvim.json              # 已启用的 LazyVim Extras
├── lazy-lock.json            # 插件版本锁定文件（提交到 git）
├── stylua.toml               # Lua 格式化配置
├── .neoconf.json             # Lua LSP 的 neodev/neoconf 配置
└── .gitignore
```

运行时目录（不要手改）：

```text
~/.local/share/lazyvim/lazy/   # 所有插件本体，含 LazyVim 自身
~/.local/state/lazyvim/        # 状态、日志、session
~/.cache/lazyvim/              # 缓存
```

查 LazyVim 默认配置的最佳位置：

```text
~/.local/share/lazyvim/lazy/LazyVim/lua/lazyvim/config/options.lua
~/.local/share/lazyvim/lazy/LazyVim/lua/lazyvim/config/keymaps.lua
~/.local/share/lazyvim/lazy/LazyVim/lua/lazyvim/config/autocmds.lua
~/.local/share/lazyvim/lazy/LazyVim/lua/lazyvim/plugins/*.lua
~/.local/share/lazyvim/lazy/LazyVim/lua/lazyvim/plugins/extras/
```

---

## 2. 启动与加载顺序

```text
nvim
 └─ init.lua
     └─ require("config.lazy")
         ├─ 检查 lazy.nvim，不存在则 git clone
         ├─ require("lazy").setup({
         │     spec = {
         │       { "LazyVim/LazyVim", import = "lazyvim.plugins" },  -- ① 框架 + 内置插件
         │       { import = "plugins" },                             -- ② lua/plugins/**
         │     }
         │  })
         └─ LazyVim 初始化
             ├─ options.lua          -- lazy 启动前立即生效
             └─ keymaps/autocmds     -- VeryLazy 时生效
```

要点：

- `lua/plugins/` 下所有 `.lua` 文件（含子目录）都会自动加载，无需手动 require，文件名随意。
- 每个插件文件必须 `return` 一个 spec 表（或表数组）。
- 同名插件的多个 spec 会合并，后加载的覆盖/补充先加载的。
- `lua/config/keymaps.lua`、`autocmds.lua` 在 `VeryLazy` 时加载；依赖插件的快捷键建议写在插件 spec 的 `keys` 中。

---

## 3. 插件 spec 基础

最短形式：

```lua
-- lua/plugins/surround.lua
return {
  "kylechui/nvim-surround",
  version = "*",
}
```

常用字段：

| 字段 | 作用 |
|---|---|
| `"owner/repo"` | 插件地址（也可写本地目录） |
| `dependencies` | 依赖插件 |
| `opts` | 传给 `require("xxx").setup(opts)` 的配置，**表会深合并** |
| `opts = function(_, opts)` | 基于已合并 opts 修改；返回表则整体替换 |
| `config = function(_, opts)` | 自定义初始化逻辑 |
| `init` | 插件加载前执行 |
| `event` / `cmd` / `keys` / `ft` | 懒加载触发条件 |
| `enabled = false` | 禁用该插件 |
| `priority` | 加载优先级，数字越大越早 |
| `version` / `branch` / `tag` / `commit` | 版本控制 |
| `build` | 安装后执行的命令 |
| `main` | 插件主模块名 |
| `dev` | 本地开发路径 |

---

## 4. 常见操作

### 4.1 安装新插件

新建 `lua/plugins/editor.lua`：

```lua
return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
}
```

保存后重启，或执行 `:Lazy sync`。

### 4.2 覆盖 LazyVim 已有插件配置

```lua
return {
  -- ① 表：与默认 opts 深合并
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },

  -- ② 函数：基于已合并的 opts 修改（推荐，保留默认值）
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.defaults.sorting_strategy = "ascending"
    end,
  },

  -- ③ 函数返回表：完全替换默认 opts
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      return { sections = { lualine_a = { "mode" } } }
    end,
  },
}
```

> 列表字段默认是**替换**而不是追加。追加列表用 `vim.list_extend`，或声明 `opts_extend`：
>
> ```lua
> {
>   "nvim-treesitter/nvim-treesitter",
>   opts_extend = { "ensure_installed" },
>   opts = { ensure_installed = { "lua", "python" } },
> }
> ```

### 4.3 禁用插件

```lua
return {
  { "folke/trouble.nvim", enabled = false },
}
```

### 4.4 使用 Extras

当前 `lazyvim.json` 已启用：

```json
"extras": [
  "lazyvim.plugins.extras.lang.json",
  "lazyvim.plugins.extras.lang.markdown",
  "lazyvim.plugins.extras.lang.python",
  "lazyvim.plugins.extras.lang.toml",
  "lazyvim.plugins.extras.lang.yaml"
]
```

推荐用 `:LazyExtras` 管理（搜索后按 `x` 启用/禁用，自动写回 `lazyvim.json`）。
也可在插件文件中临时导入：

```lua
return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
}
```

### 4.5 自定义选项、快捷键、自动命令

`lua/config/options.lua`：

```lua
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.clipboard = "unnamedplus"
```

`lua/config/keymaps.lua`：

```lua
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
```

`lua/config/autocmds.lua`：

```lua
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("user_yank_hl", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
```

### 4.6 添加自己的 Lua 模块

在 `lua/` 下新建模块，如 `lua/mylib/util.lua`：

```lua
local M = {}
function M.hello() print("hello") end
return M
```

之后 `require("mylib.util").hello()` 即可。`lua/` 本身是 runtimepath 的 Lua 根目录。

### 4.7 语言支持（LSP / 格式化 / 语法高亮）

优先用 Extras，不要手动堆 `nvim-lspconfig`：

```vim
:LazyExtras      " 启用 lang.python / lang.rust / lang.go ...
:Mason           " 安装 LSP server、formatter、linter
```

插件与外部工具的区别：

- 插件（lazy.nvim 管理）→ `~/.local/share/lazyvim/lazy/`
- LSP/formatter/linter（mason 管理）→ `~/.local/share/lazyvim/mason/`

---

## 5. 常用命令

| 命令 | 用途 |
|---|---|
| `:Lazy` 或 `<leader>l` | 插件管理界面 |
| `:Lazy sync` | 安装缺失 + 更新 + 清理 |
| `:Lazy update` | 更新插件 |
| `:Lazy reload` | 重新加载插件 spec |
| `:LazyExtras` | 管理 LazyVim Extras |
| `:LazyHealth` / `:checkhealth` | 检查环境与配置 |
| `:Mason` | 管理 LSP/formatter/linter |

---

## 6. 易踩的坑

1. **文件必须 return 表**，否则等于没配置。
2. **`opts` 表深合并、列表替换**；追加列表用函数 + `vim.list_extend` 或 `opts_extend`。
3. **自定义插件默认启动时全部加载**（`lazy.lua` 中 `defaults.lazy = false`）；插件多了应加 `event`/`cmd`/`keys`/`ft`。
4. **不要直接改 `~/.local/share/lazyvim/lazy/` 中的插件源码**，更新会被覆盖；用 spec 覆盖。
5. **提交 `lazy-lock.json` 和 `lazyvim.json`**，便于复现环境。
6. `lazyvim.json` 中 `version` / `install_version` / `news` 是自动生成的，只关心 `extras`。
7. 修改 `options.lua` 需重启；改 `lua/plugins/*.lua` 可试 `:Lazy reload`，涉及依赖/LSP 时最稳妥是重启。
8. `lua/plugins/example.lua` 是上游参考材料，被 `if true then return {} end` 禁用；不要移除 guard，也不要假设其中 spec 会加载。

---

## 7. 建议的目录组织

```text
lua/plugins/
├── editor.lua        # 编辑增强：surround、autopairs、comment...
├── ui.lua            # 主题、状态栏、bufferline
├── lsp.lua           # lspconfig / mason 覆盖
├── git.lua           # gitsigns、lazygit
├── lang/
│   ├── python.lua
│   └── rust.lua
└── disabled.lua      # 集中放 enabled = false 的插件
```

上手顺序：

1. `:LazyHealth` 确认基础环境。
2. `:LazyExtras` 启用需要的语言。
3. 在 `lua/plugins/` 加 1～2 个插件练手。
4. 逐步覆盖 LazyVim 默认插件配置，每次只改一处并重启验证。

---

## 8. 本仓库专用速查

```sh
# 启动本配置（普通 nvim 加载的是 ~/.config/nvim）
NVIM_APPNAME=lazyvim nvim

# 无头冒烟测试（期望输出 ok，退出码 0）
NVIM_APPNAME=lazyvim nvim --headless "+lua print('ok')" +qa

# 格式化 Lua（stylua 由 Mason 安装，不在 PATH）
~/.local/share/lazyvim/mason/bin/stylua .
```

插件安装/更新在编辑器内执行 `:Lazy sync`，之后提交 `lazy-lock.json`。
