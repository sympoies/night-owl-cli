# 🎨 Night Owl Palette

The single reference for every colour used across this suite. Each tool's config
is hand-written (no codegen), but `scripts/check-palette.sh` enforces that no
config may use a hex outside this list — so the palette stays the source of
truth and drift fails CI.

> Adding a new shade? Add it here **and** to `ALLOWED` in
> `scripts/check-palette.sh`, in the same PR.

## Core palette

Adapted from the [Night Owl VSCode theme](https://github.com/sdras/night-owl-vscode-theme).

| Hex       | Role                                  |
| --------- | ------------------------------------- |
| `#011627` | Background (deep navy)                |
| `#1d3b53` | Selection / subtle border             |
| `#637777` | Comment / muted / inactive            |
| `#d6deeb` | Default foreground                    |
| `#ffffff` | Bright foreground / emphasis          |
| `#82aaff` | Blue — directories, remotes, info     |
| `#c792ea` | Purple — keywords, current branch     |
| `#7fdbca` | Teal — links, strings, "yours"        |
| `#addb67` | Green — added, success, executable    |
| `#ecc48d` | Tan — tags, dates, source files       |
| `#ffcb6b` | Gold — prompts, warnings, highlights  |
| `#f78c6c` | Salmon — deleted, errors, root        |
| `#add6ff` | Light blue — file headers, video      |
| `#a1efe4` | Bright teal — "up to date" accent     |

## Documented derived / UI shades

These are intentional, tool-specific blends — not part of the core palette. They
are allow-listed so the drift check passes, and listed here so they aren't
mistaken for typos.

| Hex       | Where        | Why                                       |
| --------- | ------------ | ----------------------------------------- |
| `#0c2340` | tmux         | Status-bar background (darker than core)  |
| `#2d5a91` | tmux         | Active session / window highlight bg      |
| `#2f3b45` | delta        | Line-number gutter                        |
| `#5a3e39` | delta        | Minus (removed) line background           |
| `#764a44` | delta        | Minus emphasis background                 |
| `#945858` | delta        | Minus line-number style                   |
| `#519191` | delta        | Plus (added) line background              |
| `#5f9e9e` | delta        | Plus non-emphasis syntax                  |
| `#577c7c` | delta        | Plus line-number style                    |

## Note on the tmux background

tmux uses `#0c2340` for its status bar rather than the core `#011627`. This is
deliberate (a slightly lighter bar reads better against terminal content); it is
the one place the suite departs from the canonical background.
