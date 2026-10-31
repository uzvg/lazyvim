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

return {}
