# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- `scripts/manifest.sh` — single source of truth for what installs where, shared by `install.sh` and `uninstall.sh`.
- `PALETTE.md` + `scripts/check-palette.sh` — documented palette and a drift guard that fails on any undocumented hex.
- CI (`.github/workflows/ci.yml`): shellcheck, shfmt, palette check, and `install.sh --dry-run` smoke test.
- `.gitignore`, `.editorconfig`, and `CONTRIBUTING.md` (with an "add a new tool" guide).
- `tmux/night-owl.tmux` — colours-only tmux theme meant to be `source`d.

### Changed
- `install.sh` / `uninstall.sh` are now table-driven from the shared manifest.
- tmux is installed as a sourced fragment instead of overwriting `~/.tmux.conf`; the prefix-key rebind was dropped (theme-only).
- README path/setup instructions reconciled with the installer (k9s, fzf, tmux, starship).

### Fixed
- `random_emoji_cmd.sh` (referenced by `starship.toml`) is now installed and made executable — previously the prompt's emoji segment broke on a fresh install.
- `install_file` now honours `link`/`copy` mode even when the destination exists, and is idempotent — re-running no longer piles up `.bak` copies of our own files (backs up only a genuinely different user file, once).
- Summary loops guard empty arrays, so a mostly-skipped run no longer risks an "unbound variable" abort on older bash.
- `uninstall.sh` rebuilds the `bat` cache after removing the theme.

## v1.0.0 - 2026-01-14

### Added
- Night Owl CLI theme files for `delta`, `git`, `bat`, `eza`, `k9s`, `fzf`, `iTerm2`, `tmux`, and `starship`.
- Helper scripts: `install.sh` and `uninstall.sh` (supports `--dry-run`, `--force`).
- Documentation and screenshots in `README.md`.

### Changed
- N/A.

### Fixed
- N/A.
