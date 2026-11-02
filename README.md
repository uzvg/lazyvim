# LazyVim config

Personal Neovim config for this machine, built on [LazyVim](https://github.com/LazyVim/LazyVim).
Layout and workflow are documented in [AGENTS.md](AGENTS.md); the long-form notes
are in [docs/lazyvim-config-guide.md](docs/lazyvim-config-guide.md).

## Usage

This config lives in `~/.config/lazyvim` and is launched with `NVIM_APPNAME`:

```sh
NVIM_APPNAME=lazyvim nvim
```

Plugin data, state, and cache are kept in
`~/.local/share/lazyvim`, `~/.local/state/lazyvim`, and `~/.cache/lazyvim`.
