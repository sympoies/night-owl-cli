#!/usr/bin/env bash
# Validation gate — the one entrypoint for local dev, CI, and pre-pr.
# Requires shellcheck and shfmt on PATH.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "▶ shellcheck"
shellcheck -x install.sh uninstall.sh scripts/*.sh

echo "▶ shfmt"
shfmt -d -i 2 -ci install.sh uninstall.sh scripts/*.sh

echo "▶ palette drift"
./scripts/check-palette.sh

echo "▶ iTerm2 palette cross-check"
if command -v python3 >/dev/null 2>&1; then
  python3 scripts/check-iterm.py
else
  echo "  (skipped — python3 not installed)"
fi

echo "▶ install.sh --dry-run smoke"
./install.sh --dry-run >/dev/null

echo "▶ bats round-trip"
if command -v bats >/dev/null 2>&1; then
  bats tests/
else
  echo "  (skipped — bats not installed; CI enforces this)"
fi

echo "✅ all checks passed"
