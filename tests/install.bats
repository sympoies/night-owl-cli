#!/usr/bin/env bats
#
# Install/uninstall round-trip tests.
#
# The theme tools (delta, bat, …) usually aren't installed on a CI runner, so we
# stub them on PATH. This makes install.sh's `command -v` checks pass and lets
# the real install/uninstall logic run against an isolated $XDG_CONFIG_HOME.

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  TEST_HOME="$(mktemp -d)"
  export XDG_CONFIG_HOME="$TEST_HOME/config"
  export XDG_CACHE_HOME="$TEST_HOME/cache" # keep bat cache out of the real one

  # Stub every theme tool so detection is deterministic. The stub also answers
  # `bat cache --build` (any args) with exit 0.
  STUB_BIN="$TEST_HOME/bin"
  mkdir -p "$STUB_BIN"
  local t
  for t in delta git bat eza k9s fzf starship tmux; do
    printf '#!/bin/sh\nexit 0\n' >"$STUB_BIN/$t"
    chmod +x "$STUB_BIN/$t"
  done
  export PATH="$STUB_BIN:$PATH"

  LINK_DESTS=(
    "$XDG_CONFIG_HOME/delta/themes/night-owl.ini"
    "$XDG_CONFIG_HOME/git/night-owl-colors.gitconfig"
    "$XDG_CONFIG_HOME/k9s/skins/night-owl.yaml"
    "$XDG_CONFIG_HOME/zsh/tools/fzf-night-owl.zsh"
    "$XDG_CONFIG_HOME/starship.toml"
    "$XDG_CONFIG_HOME/tmux/night-owl.tmux"
  )
  COPY_DESTS=(
    "$XDG_CONFIG_HOME/bat/themes/Night-Owl.tmTheme"
    "$XDG_CONFIG_HOME/eza/theme.yml"
    "$XDG_CONFIG_HOME/zsh/tools/random_emoji_cmd.sh"
  )
}

teardown() {
  rm -rf "$TEST_HOME"
}

count_bak() {
  find "$XDG_CONFIG_HOME" -name '*.bak' 2>/dev/null | wc -l | tr -d ' '
}

@test "install creates the expected symlinks and copies" {
  run "$REPO_ROOT/install.sh"
  [ "$status" -eq 0 ]

  for dest in "${LINK_DESTS[@]}"; do
    [ -L "$dest" ] || {
      echo "expected symlink: $dest"
      return 1
    }
  done
  for dest in "${COPY_DESTS[@]}"; do
    [ -f "$dest" ] && [ ! -L "$dest" ] || {
      echo "expected real file: $dest"
      return 1
    }
  done

  # The starship emoji helper must be executable.
  [ -x "$XDG_CONFIG_HOME/zsh/tools/random_emoji_cmd.sh" ]
}

@test "install is idempotent — no .bak pileup of our own files" {
  "$REPO_ROOT/install.sh" >/dev/null
  "$REPO_ROOT/install.sh" >/dev/null
  [ "$(count_bak)" -eq 0 ]
}

@test "install backs up a genuinely different pre-existing file exactly once" {
  local dest="$XDG_CONFIG_HOME/delta/themes/night-owl.ini"
  mkdir -p "$(dirname "$dest")"
  printf 'user-owned theme\n' >"$dest"

  "$REPO_ROOT/install.sh" >/dev/null
  "$REPO_ROOT/install.sh" >/dev/null # second run must not add another .bak

  [ -L "$dest" ]
  [ "$(count_bak)" -eq 1 ]
  [ "$(cat "$dest.bak")" = "user-owned theme" ]
}

@test "uninstall removes our files and restores the backup" {
  local dest="$XDG_CONFIG_HOME/delta/themes/night-owl.ini"
  mkdir -p "$(dirname "$dest")"
  printf 'user-owned theme\n' >"$dest"

  "$REPO_ROOT/install.sh" >/dev/null
  run "$REPO_ROOT/uninstall.sh"
  [ "$status" -eq 0 ]

  # delta restored to the user's original (real file, original content).
  [ ! -L "$dest" ]
  [ "$(cat "$dest")" = "user-owned theme" ]

  # Everything else we installed is gone.
  for d in "${LINK_DESTS[@]}" "${COPY_DESTS[@]}"; do
    [ "$d" = "$dest" ] && continue
    [ ! -e "$d" ] || {
      echo "should have been removed: $d"
      return 1
    }
  done
  [ "$(find "$XDG_CONFIG_HOME" -type l | wc -l | tr -d ' ')" -eq 0 ]
}

@test "dry-run writes nothing" {
  run "$REPO_ROOT/install.sh" --dry-run
  [ "$status" -eq 0 ]
  [ "$(find "$XDG_CONFIG_HOME" -type f -o -type l 2>/dev/null | wc -l | tr -d ' ')" -eq 0 ]
}
