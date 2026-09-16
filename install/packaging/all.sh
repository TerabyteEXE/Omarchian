#!/usr/bin/env bash
# Packaging: install the Hyprland desktop stack from apt. Everything here
# is a real Debian package — no AUR, no third-party repos, nothing built
# from source. That's the whole point of Omarchian.

CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"

info "Installing Hyprland core (from ${CODENAME}-backports)"
if [[ "$CODENAME" == "trixie" ]]; then
  sudo apt-get install -y -t trixie-backports \
    hyprland hyprland-backgrounds xdg-desktop-portal-hyprland \
    hypridle hyprlock hyprpaper hyprcursor hyprpicker \
    >>"$OMARCHIAN_LOG_FILE" 2>&1 || die "Hyprland install failed (see $OMARCHIAN_LOG_FILE)"
else
  install_packages hyprland hyprland-backgrounds xdg-desktop-portal-hyprland \
    hypridle hyprlock hyprpaper hyprcursor hyprpicker
fi
success "Hyprland core installed"

info "Installing Wayland session essentials"
install_packages \
  seatd \
  xwayland \
  wl-clipboard \
  polkitd polkitd-pkexec \
  qt6-wayland \
  gnome-keyring \
  network-manager network-manager-gnome \
  pipewire pipewire-pulse wireplumber

info "Installing the shell: bar, launcher, notifications, lock/idle already above"
install_packages \
  waybar \
  fuzzel \
  mako-notifier \
  nautilus \
  grim slurp swappy \
  brightnessctl playerctl \
  pavucontrol

info "Installing terminal & CLI tools"
install_packages \
  alacritty \
  fastfetch \
  btop \
  git curl wget unzip \
  fonts-jetbrains-mono \
  fonts-font-awesome

# Nerd Font glyphs (used by Waybar icons and the terminal) aren't packaged
# under that name in Debian, so we fetch just the patched JetBrains Mono
# release directly from the upstream Nerd Fonts GitHub releases.
NERD_FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
if [[ ! -d "$NERD_FONT_DIR" ]]; then
  info "Installing JetBrainsMono Nerd Font"
  mkdir -p "$NERD_FONT_DIR"
  TMP_ZIP="$(mktemp --suffix=.zip)"
  if curl -fsSL -o "$TMP_ZIP" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"; then
    unzip -oq "$TMP_ZIP" -d "$NERD_FONT_DIR"
    fc-cache -f "$NERD_FONT_DIR" >>"$OMARCHIAN_LOG_FILE" 2>&1
    success "Nerd Font installed"
  else
    warn "Couldn't download the Nerd Font (offline?) — icons in Waybar/Alacritty will show as boxes until you install one manually."
  fi
  rm -f "$TMP_ZIP"
fi

# Login manager: only install one if the user has none, so we don't fight
# an existing GDM/LightDM/SDDM setup.
if ! systemctl list-unit-files | grep -qE '^(gdm3|lightdm|sddm)\.service'; then
  info "No display manager found — installing SDDM"
  install_packages sddm
  sudo systemctl enable sddm >>"$OMARCHIAN_LOG_FILE" 2>&1
else
  info "Existing display manager detected — leaving it alone"
fi

success "Packages installed"
