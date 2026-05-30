#!/usr/bin/env bash

set -euo pipefail

DRY_RUN=false

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h | --help)
      cat <<'EOF'
Usage: ./uninstall.sh [--dry-run]

Removes Night Owl files installed by install.sh and restores any .bak backups.

Options:
  --dry-run   Print actions without changing files
EOF
      exit 0
      ;;
    *)
      echo "❌ Unknown option: $1"
      exit 1
      ;;
  esac
done

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/manifest.sh
source "$ROOT_DIR/scripts/manifest.sh"

log() {
  printf "%s\n" "$1"
}

del() {
  local target="$1"
  [[ -e "$target" || -L "$target" ]] || return 0
  if [[ "$DRY_RUN" == true ]]; then
    log "🧪 DRY RUN: Would remove $target"
  else
    rm -f "$target"
    log "🗑️ Removed $target"
  fi
}

restore_bak() {
  local path="$1"
  [[ -e "$path.bak" ]] || return 0
  if [[ "$DRY_RUN" == true ]]; then
    log "🧪 DRY RUN: Would restore $path.bak → $path"
  else
    mv "$path.bak" "$path"
    log "♻️ Restored backup: $path"
  fi
}

log "🌘 Uninstalling Night Owl CLI Theme..."

bat_touched=false
for entry in "${THEME_TOOLS[@]}"; do
  # shellcheck disable=SC2034  # src/mode unused here; kept for manifest parity
  IFS='|' read -r key cmd src dest mode <<<"$entry"

  if ! command -v "$cmd" &>/dev/null; then
    log "⚠️ $cmd not installed, skipping $key"
    continue
  fi

  del "$dest"
  restore_bak "$dest"
  if [[ "$key" == "bat" ]]; then bat_touched=true; fi
done

if [[ "$bat_touched" == true && "$DRY_RUN" == false ]]; then
  bat cache --build >/dev/null 2>&1 && log "🔁 bat cache rebuilt"
fi

# iterm2 — manual removal only.
if [[ "$OSTYPE" == "darwin"* ]]; then
  log "🖐 Manually remove the iTerm2 'Night Owl' colour preset: Settings → Profiles → Colors"
fi

log "🧹 Uninstallation complete."
if [[ "$DRY_RUN" == true ]]; then
  log "(This was a dry run — no files were actually removed.)"
fi
