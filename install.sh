#!/usr/bin/env bash
# Omarchian installer — bring Omarchy's look and keyboard-driven workflow to Debian.
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/<you>/omarchian/main/boot.sh)
#    or: git clone <repo> ~/.local/share/omarchian && cd ~/.local/share/omarchian && ./install.sh

set -euo pipefail

export OMARCHIAN_PATH="${OMARCHIAN_PATH:-$HOME/.local/share/omarchian}"
export OMARCHIAN_INSTALL="$OMARCHIAN_PATH/install"
export OMARCHIAN_LOG_FILE="${OMARCHIAN_LOG_FILE:-/tmp/omarchian-install.log}"
export PATH="$OMARCHIAN_PATH/bin:$PATH"

# If we weren't run from inside the cloned repo, resolve OMARCHIAN_PATH to
# wherever this script actually lives (so `./install.sh` from a fresh
# `git clone` just works without any exporting on the user's part).
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
if [[ -f "$SCRIPT_DIR/install/helpers/all.sh" ]]; then
  OMARCHIAN_PATH="$SCRIPT_DIR"
  OMARCHIAN_INSTALL="$OMARCHIAN_PATH/install"
fi

source "$OMARCHIAN_INSTALL/helpers/all.sh"

show_logo() {
  cat <<'EOF'

   ____                            _     _             
  / __ \ _ __ ___   __ _ _ __ ___| |__ (_) __ _ _ __  
 | |  | | '_ ` _ \ / _` | '__/ __| '_ \| |/ _` | '_ \ 
 | |__| | | | | | | (_| | | | (__| | | | | (_| | | | |
  \____/|_| |_| |_|\__,_|_|  \___|_| |_|_|\__,_|_| |_|

  Keyboard-driven Hyprland, on top of boring, dependable Debian.

EOF
}

show_logo

# Each stage is a directory of scripts sourced in order by its own all.sh.
# Keeping install.sh itself tiny means someone can read the whole install
# in about thirty seconds by skimming these five lines.
source "$OMARCHIAN_INSTALL/preflight/all.sh"
source "$OMARCHIAN_INSTALL/packaging/all.sh"
source "$OMARCHIAN_INSTALL/config/all.sh"
source "$OMARCHIAN_INSTALL/post-install/all.sh"

info "Done. Log out and select 'Hyprland' at your login manager to boot in."
info "Full install log: $OMARCHIAN_LOG_FILE"
