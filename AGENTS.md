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
- Plugin specs are grouped by topic: `lua/plugins/{editor,ui,lsp,git,ai,sidekick,disabled}.lua` and `lua/plugins/lang/`. Add a new spec to the matching file rather than creating a catch-all plugin file.
- `lua/plugins/ai.lua` contains the `opencode.nvim` spec (keymaps under `<leader>a`) and its Snacks/blink.cmp/lualine integrations. Its top-level `enabled` flag is currently `false`; flip it to `true` to load the plugin and register the integrations. Because that file returns early when `enabled` is false, put any spec that must always load (e.g. sidekick overrides) elsewhere.
- `lua/plugins/sidekick.lua` overrides the `ai.sidekick` extra's CLI panel: `cli.win.split.width = 0.3` (values ≤ 1 are fractions of `vim.o.columns`, > 1 are fixed columns) plus a `VimResized` autocmd that keeps open panels at that ratio. Custom `config` must call `require("sidekick").setup(opts)` itself.
- The old `lua/plugins/example.lua` was removed; its upstream snippets are archived in `docs/example-plugins-reference.md`. That document is reference only — several plugins it mentions are obsolete or conflict with LazyVim v16 (blink.cmp vs nvim-cmp, Snacks picker vs telescope, typescript.nvim, the `mason-org` rename).
- `lazyvim.json` records enabled LazyVim extras (`lang.json`, `lang.markdown`, `lang.python`, `lang.toml`, `lang.yaml`). Change it via `:LazyExtras`, not by hand. Extras add lockfile pins with no local plugin file (e.g. `SchemaStore.nvim`, `markdown-preview.nvim`, `render-markdown.nvim`, `venv-selector.nvim`) — this is expected.

## Lockfile and versions

- `lazy-lock.json` is committed and pins exact commits. Regenerate it via lazy.nvim, never hand-edit or drop entries.
- `lua/config/lazy.lua` sets `version = false`, so plugins track latest commits (LazyVim tracks `main`). Updates can break startup: rerun the headless check afterwards.
- Runtime state is outside the repo: `~/.local/share/lazyvim` (plugins, Mason tools), `~/.local/state/lazyvim` (logs, sessions), `~/.cache/lazyvim`. Read those logs when debugging startup/plugin failures.

## Git workflow

Every feature request that changes files gets its own branch and its own set of batched commits.

1. **Branch first.** Before the first edit, run `git status --short` and `git branch --show-current`.
   - Clean tree on `main`: `git switch -c feat/<kebab-slug>`. Use the prefix that matches the work: `feat/`, `fix/`, `chore/` (tooling, deps, lockfile), or `docs/`.
   - Dirty tree: stop and ask whether to commit, stash, or carry those changes onto the new branch. Never silently mix unrelated edits into the new branch.
   - Already on a `feat/`/`fix/`/`chore/`/`docs/` branch for this same request: keep using it, don't branch again. A different feature request, even in the same session, branches again from `main`.
2. **Commit in batches.** After each self-contained unit (one plugin spec, one keymap group, one lockfile refresh, one formatting pass), stage only that unit's paths with `git add <paths>` and commit immediately.
   - Subject: Conventional Commits, e.g. `feat(plugins): add snacks toggle`, `fix(keymaps): correct <leader>gg`, `chore(lock): sync lazy-lock.json`.
   - One concern per commit. No `git add -A` grab-bags, no empty or "WIP" commits, no bundling the whole feature into one commit at the end.
   - Lua edits: run the headless smoke test before committing. A regression gets its own fix commit, not an amend.
3. **Never** amend, rebase, force-push, or push. Never commit secrets, `.env` files, or runtime state from `~/.local/...`.
4. **Report at the end:** branch name, `git log --oneline main..HEAD`, and the smoke-test result.

Read-only requests (questions, explanations, code review) do not create a branch and do not commit.
