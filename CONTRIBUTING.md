# Contributing

Thanks for helping extend the Night Owl CLI Theme Suite. This repo is small but
has two single sources of truth — keep them honest and CI stays green.

## Local checks

One script runs everything CI runs (shellcheck, shfmt, palette drift, iTerm2
palette cross-check, install/uninstall round-trip tests in `tests/`, dry-run
smoke). Run it before opening a PR:

```bash
./scripts/check.sh
```

It needs `shellcheck` and `shfmt` on `PATH`; the bats tests and iTerm2 check are
skipped locally if `bats` / `python3` are absent, but CI always runs them. To
auto-fix formatting: `shfmt -w -i 2 -ci install.sh uninstall.sh scripts/*.sh`.

## Colours

Every hex used in a theme config must be listed in [`PALETTE.md`](PALETTE.md)
and in the `ALLOWED` array of [`scripts/check-palette.sh`](scripts/check-palette.sh).
Introducing a new shade? Update both in the same PR, or the drift check fails.

Prefer the core palette. Only add a derived shade when a tool genuinely needs
one (e.g. delta's diff-background blends), and note where/why in `PALETTE.md`.

Editing the iTerm2 theme (`iterm2/Night-Owl.itermcolors`)? Its colours are
float RGB, checked separately by `scripts/check-iterm.py`. Update the `EXPECTED`
map there and `PALETTE.md` to match.

## Adding a new tool

1. Add the theme file under a new top-level directory, e.g. `zellij/night-owl.kdl`.
2. Add **one line** to [`scripts/manifest.sh`](scripts/manifest.sh):

   ```text
   "key|command|source|destination|mode"
   ```

   - `key` — unique id (also used for any per-tool post-install hook)
   - `command` — binary that must be on `PATH` for this entry to apply
   - `source` — `$ROOT_DIR/<dir>/<file>`
   - `destination` — absolute install path (prefer `$XDG_CONFIG_HOME/...`)
   - `mode` — `link` (default) or `copy` (when the tool needs a real file, e.g.
     it rebuilds a cache from it, like `bat`/`eza`)

   Both `install.sh` and `uninstall.sh` pick it up automatically.

3. Need a post-install step (cache rebuild, `chmod +x`, …)? Add a small `case`
   arm keyed by `key` in `install.sh` (see `bat` / `starship-emoji`).
4. Document setup in `README.md` and add a screenshot under `screenshots/`.
5. Run the local checks above.

## Commits

Keep theme/code/docs in English. Conventional-commit style is appreciated
(`feat(zellij): add night owl skin`).
