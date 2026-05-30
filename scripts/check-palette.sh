#!/usr/bin/env bash
# Palette drift guard.
#
# Every hex colour used across the theme configs must be a known Night Owl
# shade. This is the lightweight "single source of truth": the palette is not
# generated, but no config may drift to an undocumented colour without it
# failing here (and in CI).
#
# When you deliberately add a new shade: add it to ALLOWED below AND document
# it in PALETTE.md. Otherwise this script tells you which file introduced an
# unknown colour.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Canonical Night Owl palette + documented derived/UI shades. Keep in sync with
# PALETTE.md.
ALLOWED=(
  # ── Core palette ──
  "#011627" "#d6deeb" "#82aaff" "#c792ea" "#7fdbca" "#ecc48d"
  "#f78c6c" "#addb67" "#ffcb6b" "#637777" "#1d3b53" "#ffffff"
  "#add6ff" "#a1efe4"
  # ── tmux status-line shades ──
  "#0c2340" "#2d5a91"
  # ── delta gutter + diff blends ──
  "#2f3b45" "#5a3e39" "#764a44" "#945858" "#519191" "#5f9e9e" "#577c7c"
)

is_allowed() {
  local needle="$1" c
  for c in "${ALLOWED[@]}"; do
    [[ "$c" == "$needle" ]] && return 0
  done
  return 1
}

# The iTerm2 plist stores float RGB components, not hex, so it is excluded.
shopt -s nullglob
FILES=(
  delta/*.ini
  git/*.gitconfig
  fzf/*.zsh
  eza/*.yml
  k9s/*.yaml
  starship/*.toml
  tmux/*.tmux
)

violations=0
for f in "${FILES[@]}"; do
  while IFS=: read -r lineno hex; do
    [[ -z "$hex" ]] && continue
    hex="$(printf '%s' "$hex" | tr 'A-F' 'a-f')"
    if ! is_allowed "$hex"; then
      printf "❌ %s:%s  unknown colour %s\n" "$f" "$lineno" "$hex"
      violations=$((violations + 1))
    fi
  done < <(grep -noiE '#[0-9a-f]{6}' "$f" || true)
done

if ((violations > 0)); then
  printf "\n%d unknown colour(s) found.\n" "$violations"
  printf "If intentional, add them to ALLOWED in scripts/check-palette.sh and document in PALETTE.md.\n"
  exit 1
fi

printf "✅ palette OK — every hex is a known Night Owl shade (%d files checked)\n" "${#FILES[@]}"
