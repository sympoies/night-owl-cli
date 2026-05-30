#!/usr/bin/env bash
# Shared Night Owl tool manifest — the single source of truth for what gets
# installed and where. Sourced by both install.sh and uninstall.sh so paths are
# declared exactly once.
#
# Requires ROOT_DIR and XDG_CONFIG_HOME to be set by the caller.
#
# Each entry is "key|command|source|destination|mode":
#   key          unique id (also used for per-tool post-install hooks)
#   command      binary that must exist on PATH for this entry to apply
#   source       path inside this repo
#   destination  absolute install path
#   mode         link | copy   (bat/eza need a real file; the rest symlink)

# shellcheck disable=SC2034  # consumed by the sourcing script (install/uninstall)
THEME_TOOLS=(
  "delta|delta|$ROOT_DIR/delta/night-owl-delta.ini|$XDG_CONFIG_HOME/delta/themes/night-owl.ini|link"
  "git|git|$ROOT_DIR/git/night-owl-colors.gitconfig|$XDG_CONFIG_HOME/git/night-owl-colors.gitconfig|link"
  "bat|bat|$ROOT_DIR/bat/Night-Owl.tmTheme|$XDG_CONFIG_HOME/bat/themes/Night-Owl.tmTheme|copy"
  "eza|eza|$ROOT_DIR/eza/night-owl.yml|$XDG_CONFIG_HOME/eza/theme.yml|copy"
  "k9s|k9s|$ROOT_DIR/k9s/night-owl.yaml|$XDG_CONFIG_HOME/k9s/skins/night-owl.yaml|link"
  "fzf|fzf|$ROOT_DIR/fzf/fzf-night-owl.zsh|$XDG_CONFIG_HOME/zsh/tools/fzf-night-owl.zsh|link"
  "starship|starship|$ROOT_DIR/starship/starship.toml|$XDG_CONFIG_HOME/starship.toml|link"
  "starship-emoji|starship|$ROOT_DIR/starship/random_emoji_cmd.sh|$XDG_CONFIG_HOME/zsh/tools/random_emoji_cmd.sh|copy"
  "tmux|tmux|$ROOT_DIR/tmux/night-owl.tmux|$XDG_CONFIG_HOME/tmux/night-owl.tmux|link"
)
