#!/usr/bin/env bash
# Start continuous Hide My Email generation: one attempt every N minutes,
# with a heartbeat every 15 seconds showing totals and time until the next
# attempt. Stop with Ctrl+C.
#
# Usage: ./auto-generate.sh [label] [interval-minutes]
#   ./auto-generate.sh              # label "auto", one attempt every 8 minutes
#   ./auto-generate.sh shopping 10  # label "shopping", every 10 minutes
set -euo pipefail
cd "$(dirname "$0")"

LABEL="${1:-auto}"
EVERY_MINUTES="${2:-8}"

UV_BIN="$(command -v uv || true)"
if [ -z "$UV_BIN" ] && [ -x "$HOME/.local/bin/uv" ]; then
  UV_BIN="$HOME/.local/bin/uv"
fi
if [ -z "$UV_BIN" ]; then
  echo "uv not found. Install it first: curl -LsSf https://astral.sh/uv/install.sh | sh" >&2
  exit 1
fi

exec "$UV_BIN" run hidemyemail generate \
  --label "$LABEL" \
  --every-minutes "$EVERY_MINUTES" \
  --cookie-file cookies.txt \
  --output emails.txt
