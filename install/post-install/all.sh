#!/usr/bin/env bash
# Post-install: enable the services Hyprland needs at the seat level, add
# the user to relevant groups, and make sure Hyprland shows up as a
# session option at the login screen.

info "Enabling seatd (session/seat management)"
sudo systemctl enable --now seatd >>"$OMARCHIAN_LOG_FILE" 2>&1 || warn "Couldn't enable seatd — check $OMARCHIAN_LOG_FILE"
sudo usermod -aG seat,video,input "$USER" >>"$OMARCHIAN_LOG_FILE" 2>&1 || true

# Debian's hyprland package ships its own .desktop session file for
# display managers, but double check it landed where GDM/SDDM/LightDM look.
if [[ ! -f /usr/share/wayland-sessions/hyprland.desktop ]]; then
  warn "No hyprland.desktop session file found in /usr/share/wayland-sessions/ — your login manager may not offer Hyprland yet. A logout/login (or reboot) after this install usually fixes it."
fi

# fastfetch on shell start, the way Omarchy greets you — only add once.
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [[ -f "$rc" ]] && ! grep -q "fastfetch" "$rc"; then
    echo -e '\n# Added by Omarchian\ncommand -v fastfetch &>/dev/null && fastfetch' >>"$rc"
  fi
done

success "Post-install complete"
