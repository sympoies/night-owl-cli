#!/usr/bin/env python3
"""iTerm2 palette cross-check.

The .itermcolors plist stores colours as float RGB components, so it can't be
covered by the hex-based scripts/check-palette.sh. This converts each slot back
to hex and pins it to an expected value:

  * Core-linked slots (background, foreground, the ANSI slots that map to the
    editor palette) reuse the CORE constants below — so the iTerm theme can't
    drift away from the rest of the suite.
  * The remaining slots are Night Owl's ANSI terminal palette (bright variants
    and UI accents); they're pinned literally as a regression guard.

Change a colour on purpose? Update EXPECTED here and PALETTE.md together.
"""

import plistlib
import sys
from pathlib import Path

ITERM_FILE = Path(__file__).resolve().parent.parent / "iterm2" / "Night-Owl.itermcolors"

# Canonical core palette (must match PALETTE.md / scripts/check-palette.sh).
CORE = {
    "bg": "#011627",
    "fg": "#d6deeb",
    "blue": "#82aaff",
    "purple": "#c792ea",
    "teal": "#7fdbca",
    "green": "#addb67",
    "salmon": "#f78c6c",
    "white": "#ffffff",
    "comment": "#637777",
}

# Every colour slot in the plist, pinned to its expected hex.
EXPECTED = {
    # ── core-linked ──
    "Background Color": CORE["bg"],
    "Foreground Color": CORE["fg"],
    "Bold Color": CORE["white"],
    "Selected Text Color": CORE["white"],
    "Selection Color": CORE["comment"],
    "Ansi 0 Color": CORE["bg"],
    "Ansi 1 Color": CORE["salmon"],
    "Ansi 2 Color": CORE["green"],
    "Ansi 4 Color": CORE["blue"],
    "Ansi 5 Color": CORE["purple"],
    "Ansi 6 Color": CORE["teal"],
    "Ansi 15 Color": CORE["white"],
    # ── Night Owl ANSI terminal palette (bright variants + UI accents) ──
    "Ansi 3 Color": "#ffcb8b",
    "Ansi 7 Color": "#bec5d4",
    "Ansi 8 Color": "#44596b",
    "Ansi 9 Color": "#ef5350",
    "Ansi 10 Color": "#22da6e",
    "Ansi 11 Color": "#ffeb95",
    "Ansi 12 Color": "#5ca7e4",
    "Ansi 13 Color": "#7e57c2",
    "Ansi 14 Color": "#21c7a8",
    "Badge Color": "#ff2c6d",
    "Cursor Color": "#6f7783",
    "Cursor Guide Color": "#15fcdc",
    "Cursor Text Color": "#f3f3f3",
    "Link Color": "#78ccf0",
    "Tab Color": "#bf1a12",
}


def hex_of(color: dict) -> str:
    def chan(name: str) -> int:
        return round(color[name] * 255)

    return f"#{chan('Red Component'):02x}{chan('Green Component'):02x}{chan('Blue Component'):02x}"


def main() -> int:
    with ITERM_FILE.open("rb") as fh:
        data = plistlib.load(fh)

    color_slots = {k: v for k, v in data.items() if isinstance(v, dict) and "Red Component" in v}

    problems = []
    for slot, expected in EXPECTED.items():
        if slot not in color_slots:
            problems.append(f"missing slot: {slot}")
            continue
        actual = hex_of(color_slots[slot])
        if actual != expected:
            problems.append(f"{slot}: expected {expected}, found {actual}")

    # Any colour slot in the file we don't pin is unchecked drift.
    for slot in color_slots:
        if slot not in EXPECTED:
            problems.append(f"unpinned slot: {slot} ({hex_of(color_slots[slot])}) — add it to EXPECTED")

    if problems:
        print("❌ iTerm2 palette mismatch:")
        for p in problems:
            print(f"   {p}")
        print("\nIf intentional, update EXPECTED in scripts/check-iterm.py and PALETTE.md.")
        return 1

    print(f"✅ iTerm2 palette OK — {len(EXPECTED)} slots pinned and consistent with the core palette")
    return 0


if __name__ == "__main__":
    sys.exit(main())
