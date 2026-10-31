# 从 `example.lua` 拆出的插件配置参考

原 `lua/plugins/example.lua` 是 LazyVim starter 自带的上游示例，首行
`if true then return {} end` 让它完全不会加载。它基于较老的 LazyVim/Neovim 生态，
其中不少写法在当前的 LazyVim v16 上已经过时，或者会与内置插件冲突。

因此这里按主题保留其中有参考价值的内容，**不要整段复制启用**。需要时把对应片段
放进 `lua/plugins/<topic>.lua`，并按当前插件版本调整。

---

## 一、先看冲突与过时项

| 原示例 | 当前状态 | 建议做法 |
| --- | --- | --- |
| `hrsh7th/nvim-cmp` + `cmp-emoji` | LazyVim v16 使用 **blink.cmp**，`nvim-cmp` 未安装 | 改 `blink.cmp` 的 `opts.sources`，不要装 `nvim-cmp` |
| `nvim-telescope/telescope.nvim` | LazyVim v16 使用 **Snacks picker**，未安装 telescope | 用 `Snacks.picker.*`；确需 telescope 再单独安装 |
| `jose-elias-alvarez/typescript.nvim` | 项目已停止维护，且依赖旧版 API | 启用 `lang.typescript` extra，或使用 `vtsls`/`ts_ls` |
| `williamboman/mason.nvim` | 插件已迁移到 `mason-org/mason.nvim` | 覆盖时使用新仓库名 |
| `nvim-treesitter` 的 `ensure_installed` 大列表 | 列表默认**整体替换**，会覆盖 LazyVim 默认解析器 | 用 `opts_extend` 或 `opts = function(_, opts) vim.list_extend(...) end` |
| `pyright` 手动加进 lspconfig | `lang.python` extra 已包含 pyright + ruff | 不要重复添加，直接改 extra 的 opts |
| `{ import = "lazyvim.plugins.extras.lang.json" }` | `lazyvim.json` 已启用该 extra | 用 `:LazyExtras` 管理，避免重复 import |
| `mason` 的 `ensure_installed` 工具 | `stylua`、`shfmt` LazyVim 默认已安装 | 只追加确实需要的工具（如 `shellcheck`） |

---

## 二、编辑与 UI（可按需启用，基本无冲突）

### 2.1 换主题

```lua
-- lua/plugins/ui.lua
return {
  { "ellisonleao/gruvbox.nvim" },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "gruvbox" },
  },
}
```

### 2.2 覆盖 trouble.nvim 配置

```lua
-- lua/plugins/ui.lua
return {
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },
}
```

### 2.3 禁用 LazyVim 自带插件

```lua
-- lua/plugins/disabled.lua
return {
  { "folke/trouble.nvim", enabled = false },
}
```

### 2.4 lualine：追加一个 section

```lua
-- lua/plugins/ui.lua
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "OK"
        end,
      })
    end,
  },
}
```

### 2.5 lualine：完全替换默认配置

```lua
-- lua/plugins/ui.lua
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        -- 在这里写完整的 lualine 配置
      }
    end,
  },
}
```

---

## 三、搜索与补全（不要照抄旧示例）

### 3.1 旧 telescope 写法（仅存档）

当前 LazyVim v16 没有安装 telescope，下面这段不能直接使用：

```lua
-- 旧写法：需要先自行安装 nvim-telescope/telescope.nvim
{
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>fp",
      function()
        require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
      end,
      desc = "Find Plugin File",
    },
  },
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
    },
  },
}
```

现代等价做法是使用 `Snacks.picker`，具体 keymap 可参考
`~/.local/share/lazyvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua`。

### 3.2 旧 nvim-cmp 写法（仅存档）

LazyVim v16 使用 blink.cmp，下面这段已不适用：

```lua
{
  "hrsh7th/nvim-cmp",
  dependencies = { "hrsh7th/cmp-emoji" },
  opts = function(_, opts)
    table.insert(opts.sources, { name = "emoji" })
  end,
}
```

要扩展补全来源，请改 `blink.cmp` 的 `opts`，并查看其文档。

---

## 四、LSP / 语言支持

### 4.1 Python

`lang.python` extra 已经提供 `pyright` + `ruff`，不需要再手动加：

```lua
-- 不需要这样做，extra 已包含
{ "neovim/nvim-lspconfig", opts = { servers = { pyright = {} } } }
```

如果要改 Python 的 LSP 选择，**必须在 extra 加载前设置**，推荐放到
`lua/config/options.lua`：

```lua
vim.g.lazyvim_python_lsp = "basedpyright" -- 或 "pyright"
```

### 4.2 TypeScript

不要再使用已废弃的 `typescript.nvim`。优先启用 extra：

```vim
:LazyExtras
" 搜索并启用 lang.typescript
```

### 4.3 追加 treesitter 解析器

LazyVim 默认已包含 bash、html、javascript、json、lua、markdown、python、tsx、
typescript、yaml 等解析器。确实需要追加时：

```lua
-- lua/plugins/editor.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts_extend = { "ensure_installed" },
    opts = { ensure_installed = { "dockerfile", "gitignore" } },
  },
}
```

或者用函数追加：

```lua
{
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, { "dockerfile", "gitignore" })
  end,
}
```

---

## 五、Extras 与 Mason 工具

### 5.1 Extras 不要重复 import

原示例里的：

```lua
{ import = "lazyvim.plugins.extras.lang.typescript" },
{ import = "lazyvim.plugins.extras.lang.json" },
{ import = "lazyvim.plugins.extras.ui.mini-starter" },
```

更推荐用 `:LazyExtras` 启用，结果会写入 `lazyvim.json`，便于统一管理。
当前已启用：`lang.json`、`lang.markdown`、`lang.python`、`lang.toml`、`lang.yaml`。

### 5.2 追加 Mason 工具

`stylua` 和 `shfmt` 默认已安装，只需追加额外工具：

```lua
-- lua/plugins/lsp.lua
return {
  {
    "mason-org/mason.nvim",
    opts_extend = { "ensure_installed" },
    opts = { ensure_installed = { "shellcheck" } },
  },
}
```

---

## 六、结论

- 原 `example.lua` 的内容**没有一条是当前配置必需的**：语言支持看 extras，补全/搜索/UI
  由 LazyVim 内置插件提供。
- 要新增插件，按主题写进 `lua/plugins/editor.lua`、`ui.lua`、`lsp.lua`、`git.lua`
  或 `lua/plugins/lang/`。
- 每次改动后运行无头测试：

```sh
NVIM_APPNAME=lazyvim nvim --headless "+lua print('ok')" +qa
```
