# AGENTS.md

Personal Neovim config built on the LazyVim starter. There is no application code, build, test suite, CI, or pre-commit hooks — only Lua config and a plugin lockfile.

## Commands

- Launch this config: `NVIM_APPNAME=lazyvim nvim`. Plain `nvim` loads `~/.config/nvim`, not this repo.
- Headless smoke test after edits: `NVIM_APPNAME=lazyvim nvim --headless "+lua print('ok')" +qa`
  (expected output `ok`, exit 0; startup errors print to stderr). Use this instead of opening a TUI.
- Format Lua: `~/.local/share/lazyvim/mason/bin/stylua .` — StyLua is installed by Mason and is **not on `PATH`**.
  Settings live in `stylua.toml` (2-space indent, 120 columns).
- Plugin install/sync/lock refresh is in-editor: `:Lazy sync` (or `:Lazy update`), then commit the lockfile.

## Layout and loading

- `init.lua` only calls `require("config.lazy")`, which bootstraps lazy.nvim into `~/.local/share/lazyvim/lazy/lazy.nvim`.
- `lua/config/{options,keymaps,autocmds}.lua` are sourced automatically by LazyVim (startup / VeryLazy). They are empty stubs; LazyVim supplies the defaults.
- Add plugins as new files under `lua/plugins/`; lazy.nvim imports the whole directory. Don't add specs to `lua/config/lazy.lua` unless changing lazy.nvim itself.
- Plugin specs are grouped by topic: `lua/plugins/{editor,ui,lsp,git,ai,disabled}.lua` and `lua/plugins/lang/`. Add a new spec to the matching file rather than creating a catch-all plugin file.
- `lua/plugins/ai.lua` configures `opencode.nvim` (keymaps under `<leader>a`) and integrates it with Snacks input/picker/terminal, blink.cmp, and lualine. It loads at startup because its event/permission autocmds must be registered early.
- The old `lua/plugins/example.lua` was removed; its upstream snippets are archived in `docs/example-plugins-reference.md`. That document is reference only — several plugins it mentions are obsolete or conflict with LazyVim v16 (blink.cmp vs nvim-cmp, Snacks picker vs telescope, typescript.nvim, the `mason-org` rename).
- `lazyvim.json` records enabled LazyVim extras (`lang.json`, `lang.markdown`, `lang.python`, `lang.toml`, `lang.yaml`). Change it via `:LazyExtras`, not by hand. Extras add lockfile pins with no local plugin file (e.g. `SchemaStore.nvim`, `markdown-preview.nvim`, `render-markdown.nvim`, `venv-selector.nvim`) — this is expected.

## Lockfile and versions

- `lazy-lock.json` is committed and pins exact commits. Regenerate it via lazy.nvim, never hand-edit or drop entries.
- `lua/config/lazy.lua` sets `version = false`, so plugins track latest commits (LazyVim tracks `main`). Updates can break startup: rerun the headless check afterwards.
- Runtime state is outside the repo: `~/.local/share/lazyvim` (plugins, Mason tools), `~/.local/state/lazyvim` (logs, sessions), `~/.cache/lazyvim`. Read those logs when debugging startup/plugin failures.
