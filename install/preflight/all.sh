#!/usr/bin/env bash
# Preflight: make sure we're actually on Debian, that backports is enabled
# (Hyprland lives there as of trixie), and grab sudo once up front so the
# rest of the install can run unattended.

[[ -f /etc/debian_version ]] || die "Omarchian targets Debian. This isn't Debian (or a Debian derivative that kept /etc/debian_version)."

if ! command -v sudo &>/dev/null; then
  die "sudo is required. Install it as root first: apt-get install sudo"
fi

info "Requesting sudo — you'll need it for package installs."
sudo -v
# Keep sudo alive for the duration of the install.
( while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done ) &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT

CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"
info "Detected Debian codename: ${CODENAME:-unknown}"

if [[ "$CODENAME" != "trixie" && "$CODENAME" != "sid" && "$CODENAME" != "forky" ]]; then
  warn "Omarchian is built and tested against Debian 13 (trixie) and newer."
  warn "You're on '${CODENAME:-unknown}' — Hyprland's backport may not exist for this release yet."
  read -rp "Continue anyway? (y/N): " -n 1 REPLY; echo
  [[ "$REPLY" =~ ^[Yy]$ ]] || exit 1
fi

# Hyprland and friends live in trixie-backports, not main, as of Debian 13.
BACKPORTS_LINE="deb http://deb.debian.org/debian ${CODENAME}-backports main contrib non-free non-free-firmware"
SOURCES_FILE="/etc/apt/sources.list.d/${CODENAME}-backports.list"

if [[ "$CODENAME" == "trixie" ]] && ! grep -rq "backports" /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null; then
  info "Enabling ${CODENAME}-backports (needed for Hyprland)"
  echo "$BACKPORTS_LINE" | sudo tee "$SOURCES_FILE" >/dev/null
  log "Wrote $SOURCES_FILE"
fi

run_logged "Updating package lists" sudo apt-get update

success "Preflight checks passed"
