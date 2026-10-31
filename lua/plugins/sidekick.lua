-- sidekick.nvim：LazyVim 的 `ai.sidekick` extra 已在 lazyvim.json 中启用，
-- 这里只覆盖 CLI 面板（<leader>aa 等打开的 agent 窗口）的尺寸行为。
--
-- 默认 `cli.win.split.width = 80` 是固定列数，窗口再大面板也只有 80 列。
-- sidekick 的换算规则（lua/sidekick/cli/terminal.lua）：
--   width <= 1  → 占 vim.o.columns 的比例
--   width >  1  → 固定列数
-- 因此下面用 0.3 表示“占编辑器宽度的 30%”。
--
-- 另外宽度只在窗口打开时计算一次，所以补一个 VimResized 回调，
-- 让已经打开的面板在编辑器窗口尺寸变化时实时跟随。
--
-- 注意：一旦自定义 config，就必须自己调用 require("sidekick").setup(opts)，
-- 否则 LazyVim 的默认 setup 不会执行。
return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        win = {
          split = {
            width = 0.3, -- <= 1 表示比例
            height = 0.3, -- layout 为 top/bottom 时的比例
          },
        },
      },
    },
    config = function(_, opts)
      require("sidekick").setup(opts)

      --- 按比例调整已打开的面板，使其跟随编辑器窗口尺寸。
      local function resize()
        for _, session in ipairs(require("sidekick.cli.terminal").sessions()) do
          if session:is_open() then
            local layout = session.opts.layout
            if layout == "top" or layout == "bottom" then
              local ratio = session.opts.split.height
              if ratio and ratio > 0 and ratio <= 1 then
                vim.api.nvim_win_set_height(session.win, math.floor(vim.o.lines * ratio))
              end
            elseif layout ~= "float" then
              local ratio = session.opts.split.width
              if ratio and ratio > 0 and ratio <= 1 then
                vim.api.nvim_win_set_width(session.win, math.floor(vim.o.columns * ratio))
              end
            end
          end
        end
      end

      vim.api.nvim_create_autocmd("VimResized", {
        group = vim.api.nvim_create_augroup("user_sidekick_resize", { clear = true }),
        callback = resize,
      })
    end,
  },
}
