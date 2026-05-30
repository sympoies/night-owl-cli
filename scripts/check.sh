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

echo "▶ install.sh --dry-run smoke"
./install.sh --dry-run >/dev/null

echo "✅ all checks passed"
