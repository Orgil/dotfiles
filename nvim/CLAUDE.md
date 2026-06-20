# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration (used as `~/.config/nvim`), built on `lazy.nvim` for plugin
management. There is no build/test/lint pipeline — changes are validated by launching Neovim and
exercising the affected functionality (or `:Lazy` / `:checkhealth` / `:Mason`).

## Common commands

- Reload after editing config: restart Neovim, or `:source %` for the current file when safe.
- Manage plugins: `:Lazy` (sync/update/clean), `:Lazy log` to see changes.
- Manage LSP servers/formatters/linters: `:Mason`.
- Check formatter status for current buffer: `:ConformInfo`.
- Validate Lua syntax quickly from the shell: `nvim --headless -c "luafile lua/<file>.lua" -c "qa"`.
- `lazy-lock.json` pins exact plugin commits — committed changes to it reflect real `:Lazy update` runs;
  avoid hand-editing it.

## Architecture

Load order, from `init.lua`:
1. `lua/settings.lua` — raw `vim.opt`/`vim.g` options (no plugin dependencies).
2. `lua/mappings.lua` — global keymaps not tied to a specific plugin/LSP, via `require("utils").map`.
3. Bootstraps `lazy.nvim` if not present, then `require("lazy").setup({ spec = { { import = "plugins" } } })`.

Plugin specs are split into two layers, both picked up by the `{ import = "plugins" }` spec:
- `lua/plugins.lua` — a flat list of misc plugin specs (colorscheme, UI, editing, terminal, etc.).
- `lua/plugins/*.lua` — one file per plugin/feature area (e.g. `telescope.lua`, `treesitter.lua`,
  `neotest.lua`, `dashboard.lua`). Each returns a lazy.nvim spec table (or list of tables).
- `lua/plugins/lsp/` is the LSP/formatting/linting subsystem:
  - `init.lua` defines `nvim-lspconfig` (with per-server `settings`/`setup` overrides, e.g. `gopls`,
    `vtsls`, `clangd`, `rust_analyzer`, `lua_ls`), plus `conform.nvim` (formatters by filetype) and
    `nvim-lint` (linters by filetype) as sibling specs in the same returned list.
  - `keymaps.lua` exports a table keyed by LSP client name (`default`, `tsserver`, `rust_analyzer`,
    ...). `init.lua`'s `LspAttach` autocmd always calls `keymaps.default()`, then calls
    `keymaps[client.name]()` if it exists — this is how per-server keymaps (e.g. rust-tools hover
    actions) are layered on top of the defaults.

`lua/utils.lua` provides shared helpers used across plugin files:
- `utils.map(mode, lhs, rhs, opts)` — thin wrapper over `vim.keymap.set` with `noremap`/`silent`
  defaults; used everywhere instead of calling `vim.keymap.set` directly.
- `utils.icons` — shared icon tables (`diagnostics`, `git`, `kinds`) consumed by LSP diagnostics
  signs, completion, and statusline/UI plugins so icon sets stay consistent.

Formatting/linting wiring (`lua/plugins/lsp/init.lua`):
- `conform.nvim` maps filetypes to formatters (e.g. Go → `goimports`+`golines`, JS/TS → `biome` falling
  back to `prettierd`/`prettier`, SQL → `sql_formatter` using `sql-formatter.json` config at repo root).
  Format-on-save is enabled with `lsp_format = "fallback"`.
- `nvim-lint` maps filetypes to linters (e.g. Go → `golangcilint`, YAML → `yamllint`) and runs on
  `BufEnter`/`BufWritePost`/`InsertLeave` via a debounced autocmd.
- `mason.nvim` ensures the above formatter/linter/debugger binaries are installed; LSP servers are
  installed via `mason-lspconfig` unless a server entry sets `mason = false` (manual setup) or isn't
  available through Mason.

`snippets/` holds per-language snippet JSON (consumed by the completion/snippet plugin configured in
`lua/plugins/cmp.lua`).

Leader key is `,` (set in `lua/mappings.lua`). Many LSP-related mappings (go to definition, references,
rename, code actions) live in `lua/plugins/lsp/keymaps.lua` rather than `lua/mappings.lua` because they
depend on an attached LSP client.
