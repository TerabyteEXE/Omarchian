#!/usr/bin/env bash
# Shared helpers sourced by every other stage. Keep this dependency-free —
# it has to work before we've installed anything.

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
BLUE=$'\033[0;34m'
RESET=$'\033[0m'

log() {
  echo "$(date '+%H:%M:%S') $*" >>"$OMARCHIAN_LOG_FILE"
}

info() {
  echo "${BLUE}==>${RESET} $*"
  log "INFO: $*"
}

success() {
  echo "${GREEN}✓${RESET} $*"
  log "OK: $*"
}

warn() {
  echo "${YELLOW}!${RESET} $*" >&2
  log "WARN: $*"
}

die() {
  echo "${RED}✗ $*${RESET}" >&2
  log "FATAL: $*"
  exit 1
}

# Run a command, streaming its output only to the log file unless it fails —
# keeps the terminal readable the way Omarchy's installer does.
run_logged() {
  info "$1"
  shift
  if ! "$@" >>"$OMARCHIAN_LOG_FILE" 2>&1; then
    die "Failed: $* (see $OMARCHIAN_LOG_FILE)"
  fi
}

package_installed() {
  dpkg -s "$1" &>/dev/null
}

install_packages() {
  local to_install=()
  for pkg in "$@"; do
    package_installed "$pkg" || to_install+=("$pkg")
  done
  if [[ ${#to_install[@]} -eq 0 ]]; then
    return 0
  fi
  info "Installing: ${to_install[*]}"
  if ! sudo apt-get install -y "${to_install[@]}" >>"$OMARCHIAN_LOG_FILE" 2>&1; then
    die "apt-get install failed for: ${to_install[*]} (see $OMARCHIAN_LOG_FILE)"
  fi
}

# Symlink a config directory from the repo into ~/.config, backing up
# anything that's already there instead of clobbering it.
link_config() {
  local src="$OMARCHIAN_PATH/config/$1"
  local dest="$HOME/.config/$1"
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    mv "$dest" "$dest.bak.$(date +%Y%m%d-%H%M%S)"
    warn "Backed up existing ~/.config/$1"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  success "Linked $1"
}
