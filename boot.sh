#!/usr/bin/env bash
# Fetches Omarchian and hands off to install.sh.
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/<you>/omarchian/main/boot.sh)

set -euo pipefail

OMARCHIAN_PATH="${OMARCHIAN_PATH:-$HOME/.local/share/omarchian}"
OMARCHIAN_REPO="${OMARCHIAN_REPO:-https://github.com/<you>/omarchian.git}"
OMARCHIAN_REF="${OMARCHIAN_REF:-main}"

if ! command -v git &>/dev/null; then
  echo "Installing git..."
  sudo apt-get update && sudo apt-get install -y git
fi

if [[ -d "$OMARCHIAN_PATH" ]]; then
  mv "$OMARCHIAN_PATH" "$OMARCHIAN_PATH.backup.$(date +%Y%m%d-%H%M%S)"
fi

echo "Cloning Omarchian ($OMARCHIAN_REF)..."
git clone --branch "$OMARCHIAN_REF" "$OMARCHIAN_REPO" "$OMARCHIAN_PATH"

exec bash "$OMARCHIAN_PATH/install.sh"
