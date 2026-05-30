#!/usr/bin/env bash

set -euo pipefail

DRY_RUN=false
FORCE=false

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    -h | --help)
      cat <<'EOF'
Usage: ./install.sh [--dry-run] [--force]

Options:
  --dry-run   Print actions without changing files
  --force     Overwrite without creating .bak backups
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

INSTALLED=()
SKIPPED=()

echo "🌙 Installing Night Owl CLI Theme Suite..."
echo "📅 Started install at $(date)"

log_success() {
  printf "✅ %s\n" "$1"
  INSTALLED+=("$1")
}

log_skip() {
  printf "⚠️  %s\n" "$1"
  SKIPPED+=("$1")
}

install_file() {
  local src="$1"
  local dest="$2"
  local label="$3"
  local mode="${4:-link}"

  if [[ "$DRY_RUN" == true ]]; then
    echo "🧪 DRY RUN: Would install $label ($mode) → $dest"
    return
  fi

  mkdir -p "$(dirname "$dest")"

  # Back up only a genuinely different pre-existing file, once. `cmp` follows
  # symlinks, so our own symlink or a prior copy compares equal to $src and is
  # never backed up — install stays idempotent and won't pile up .bak files.
  if [[ -e "$dest" && "$FORCE" == false && ! -e "$dest.bak" ]] && ! cmp -s "$src" "$dest"; then
    cp "$dest" "$dest.bak"
    log_success "Backup created: $dest.bak"
  fi

  case "$mode" in
    copy)
      cp -f "$src" "$dest"
      log_success "$label installed (copy)"
      ;;
    link)
      ln -sf "$src" "$dest"
      log_success "$label linked"
      ;;
    *)
      echo "❌ Unknown install mode: $mode"
      return 1
      ;;
  esac
}

for entry in "${THEME_TOOLS[@]}"; do
  IFS='|' read -r key cmd src dest mode <<<"$entry"

  if ! command -v "$cmd" &>/dev/null; then
    log_skip "$cmd not found, skipping $key"
    continue
  fi

  install_file "$src" "$dest" "$key" "$mode"

  if [[ "$DRY_RUN" == false ]]; then
    case "$key" in
      bat)
        bat cache --build >/dev/null 2>&1 && log_success "bat cache rebuilt"
        ;;
      starship-emoji)
        chmod +x "$dest"
        ;;
    esac
  fi
done

# ───── iterm2 (manual import only) ─────
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "📦 Import iterm2/Night-Owl.itermcolors via iTerm2 → Settings → Profiles → Colors → Color Presets → Import"
else
  log_skip "iTerm2 theme skipped (non-macOS)"
fi

printf "\n📋 Install Summary\n"
if ((${#INSTALLED[@]})); then
  for item in "${INSTALLED[@]}"; do echo "  ✅ $item"; done
fi
if ((${#SKIPPED[@]})); then
  for item in "${SKIPPED[@]}"; do echo "  ⚠️ $item (skipped)"; done
fi

if [[ "$DRY_RUN" == true ]]; then
  printf "\n🧪 This was a dry run — no files were actually changed.\n"
fi

echo "🎉 Night Owl CLI Theme setup complete."
