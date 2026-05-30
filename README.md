# 🌙 Night Owl CLI Theme Suite

A fully synchronized CLI color theme based on the famous **Night Owl** palette, redesigned for **low-light, high-focus terminal environments**.

This project brings Night Owl's signature cool tones and soft contrasts to your favorite command-line tools, including:

- 🐙 `delta` – Git diff viewer
- 🌳 `git` – log/branch colors
- 🐱 `bat` – Syntax-highlighting cat replacement
- 🦉 `eza` – Modern `ls` replacement
- 🛁 `k9s` – Kubernetes TUI client
- 🧬 `fzf` – Fuzzy finder with preview integration
- 🔮 `iterm2` – Terminal emulator color scheme
- 🧪 `tmux` – Status line and pane border theming
- 🚀 `starship` – Minimal prompt with semantic color cues

## 🎯 Philosophy

> Night Owl is more than a theme — it’s a workspace ritual.

- Optimized for **focus** and **clarity** in low-light environments
- Reduces eye strain without sacrificing syntax readability
- Carefully selected saturation and brightness levels per tool

## 📁 Directory Structure

```text
night-owl-cli/
│
├── delta/night-owl-delta.ini
├── git/night-owl-colors.gitconfig
├── bat/Night-Owl.tmTheme
├── eza/night-owl.yml
├── k9s/night-owl.yaml
├── fzf/fzf-night-owl.zsh
├── iterm2/Night-Owl.itermcolors
├── tmux/night-owl.tmux
├── starship/
│   ├── starship.toml
│   └── random_emoji_cmd.sh
│
├── scripts/
│   ├── manifest.sh        # single source of truth: what installs where
│   ├── check.sh           # one entrypoint for all checks (local + CI)
│   ├── check-palette.sh   # palette drift guard
│   └── check-iterm.py     # iTerm2 palette cross-check
├── tests/
│   └── install.bats       # install/uninstall round-trip tests
├── PALETTE.md             # canonical colour reference
├── install.sh
└── uninstall.sh
```

## 🔧 Setup Instructions

### 🔹 Quick Start (Optional)

A helper script is available for auto-installation of supported components:

```bash
./install.sh
```

This script:

- Installs each theme **only if the related tool is installed**
- Backs up an existing, differing config once (`.bak`) before replacing it
- Symlinks (or copies, where the tool needs a real file) into the right location
- Is **safe to re-run** — it won't pile up backups of its own files

> ⚠️ If you already have custom config for any tool, **review and merge manually**.
> Do **not run blindly** unless you're fully aware of the changes.

When in doubt: **install one tool at a time by following the steps below.**

---

### 🐙 delta

1. Copy `delta/night-owl-delta.ini` to `~/.config/delta/themes/night-owl.ini`
2. In `~/.gitconfig`, include the theme config:

   ```ini
   [include]
       path = ~/.config/delta/themes/night-owl.ini

   [delta]
       syntax-theme = "Night-Owl"
       features = "night-owl"
   ```

> ✅ **Note:** Do **not** manually copy the `[delta "night-owl"]` block into `~/.gitconfig`.
> Use `[include]` instead to ensure full compatibility with delta's features mechanism.

![Preview](./screenshots/delta-preview.png)

---

### 🌳 git

1. Copy `git/night-owl-colors.gitconfig` to `~/.config/git/night-owl-colors.gitconfig`
2. In `~/.gitconfig`, include the config:

   ```ini
   [include]
       path = ~/.config/git/night-owl-colors.gitconfig
   ```

3. Try:

   ```bash
   git log --graph --decorate --oneline --all
   ```

![Preview](./screenshots/git-preview.png)

---

### 🐱 bat

1. Copy `bat/Night-Owl.tmTheme` to `~/.config/bat/themes/`
2. Run: `bat cache --build`
3. Set theme: `export BAT_THEME="Night-Owl"`

![Preview](./screenshots/bat-preview.png)

---

### 🦉 eza

1. Copy `eza/night-owl.yml` to `~/.config/eza/theme.yml`
2. Set config directory (e.g. in your `.zshrc` / `.bashrc`):

   ```sh
   export EZA_CONFIG_DIR=~/.config/eza
   ```

![Preview](./screenshots/eza-preview.png)

---

### 🛁 k9s

1. Copy `k9s/night-owl.yaml` to `~/.config/k9s/skins/night-owl.yaml`
   (the installer uses `$XDG_CONFIG_HOME/k9s/skins/`; run `k9s info` to confirm
   your skins dir if it differs)
2. Point k9s at the skin in its `config.yaml`. Recent k9s (v0.30+):

   ```yaml
   k9s:
     ui:
       skin: night-owl
   ```

   Older k9s versions use a top-level `k9s.skin: night-owl`.

![Preview](./screenshots/k9s-preview.png)

---

### 🧬 fzf

1. The installer places the file at `~/.config/zsh/tools/fzf-night-owl.zsh`.
   Source it from your shell config (`.zshrc`):

   ```sh
   source ~/.config/zsh/tools/fzf-night-owl.zsh
   ```

![Preview](./screenshots/fzf-preview.png)

---

### 🔮 iterm2

1. Go to `Preferences → Profiles → Colors → Color Presets... → Import...`
2. Select `iterm2/Night-Owl.itermcolors`
3. Apply the theme from the Presets dropdown

![Preview](./screenshots/iterm2-preview.png)

---

### 🧪 tmux

The tmux theme is **colours only** — it does not touch your prefix key or other
settings, and the installer never overwrites your `~/.tmux.conf`.

1. The installer places `tmux/night-owl.tmux` at `~/.config/tmux/night-owl.tmux`.
2. Source it from your own `~/.tmux.conf`:

   ```tmux
   source-file ~/.config/tmux/night-owl.tmux
   ```

3. Reload: `tmux source-file ~/.tmux.conf`

> Night Owl uses 24-bit hex colours. For exact rendering, enable truecolor:
> `set -as terminal-features ",*:RGB"`

![Preview](./screenshots/tmux-preview.png)

---

### 🚀 starship

1. Replace or merge into `~/.config/starship.toml`
2. `random_emoji_cmd.sh` powers the `[custom.emoji]` prompt segment. `install.sh`
   copies it to `~/.config/zsh/tools/random_emoji_cmd.sh` and marks it executable
   automatically. Installing `starship.toml` by hand? Place the script there
   yourself and `chmod +x` it, or update the path in `starship.toml`.

> This script generates a random emoji for each prompt refresh 🎲

![Preview](./screenshots/starship-preview.png)

---

## 🗑️ Uninstall Instructions

To remove all installed Night Owl configurations, run:

```bash
  ./uninstall.sh
```

This will:

- Remove all Night Owl theme/config files installed by install.sh
- Restore any .bak backups that were created during installation

To preview what would be removed without making changes:

```bash
  ./uninstall.sh --dry-run
```

⚠️ iTerm2 color presets must be removed manually:
  Preferences → Profiles → Colors → Color Presets... → Remove 'Night Owl'

⚠️ If you added a Git `[include] path = ~/.config/git/night-owl-colors.gitconfig`, remove it manually.

This script only affects files created by install.sh. If you've merged configs manually,
please review them before running uninstall.

## 🛠 Development

The colour set lives in [`PALETTE.md`](PALETTE.md) and what-installs-where lives
in [`scripts/manifest.sh`](scripts/manifest.sh) — both single sources of truth.
One script runs every check (shellcheck, shfmt, palette drift, iTerm2 palette
cross-check, install/uninstall round-trip tests, dry-run smoke), locally and in
CI (`.github/workflows/ci.yml`):

```bash
./scripts/check.sh          # needs shellcheck, shfmt (+ bats, python3 for the full set)
```

**Adding a new tool** is one line in `scripts/manifest.sh`
(`key|command|source|destination|mode`), shared by install and uninstall. See
[CONTRIBUTING.md](CONTRIBUTING.md).

## 🪪 License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

This project is licensed under the MIT License. See [LICENSE](LICENSE).
Theme color values adapted from [Night Owl VSCode theme](https://github.com/sdras/night-owl-vscode-theme) by Sarah Drasner.

This project is a CLI-oriented adaptation for personal and community use.

---

*Contributions welcome. Pull requests for additional tool integrations or refinements appreciated.*
