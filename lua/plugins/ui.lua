-- 界面相关：主题、状态栏、bufferline、通知等。
--
-- 换主题示例（LazyVim 默认 tokyonight）：
-- { "ellisonleao/gruvbox.nvim" },
-- { "LazyVim/LazyVim", opts = { colorscheme = "gruvbox" } },
--
-- 覆盖 lualine 示例：
-- {
--   "nvim-lualine/lualine.nvim",
--   event = "VeryLazy",
--   opts = function(_, opts)
--     table.insert(opts.sections.lualine_x, { function() return "OK" end })
--   end,
-- },

-- Snacks 图片预览（Kitty Graphics Protocol，支持 kitty/wezterm/ghostty）。
-- 启用后可直接打开图片，并在 Markdown 中内联渲染图片与公式。
return {
  -- Ayu Dark 主题（Lua 版 ayu-vim）：https://github.com/Shatur/neovim-ayu
  -- 与 kitty 的 ayu_dark 终端配色保持一致。
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    main = "ayu", -- lazy.nvim 默认按仓库名 require("neovim-ayu")，实际模块名是 ayu
    opts = {
      mirage = false, -- dark 变体，而不是 mirage
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "ayu-dark",
    },
  },
  -- neovim-ayu 自带 lualine 主题；LazyVim 的 "auto" 认不出 ayu-dark 这个名字。
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "ayu",
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = true,
      },
    },
  },
}
