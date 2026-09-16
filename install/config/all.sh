#!/usr/bin/env bash
# Config: symlink this repo's config/ directory into ~/.config, one app at
# a time, backing up whatever's already there. Editing ~/.config/hypr/* then
# just edits the repo in place — same idea as Omarchy's dotfiles.

mkdir -p "$HOME/.config"

for app in hypr waybar fuzzel mako alacritty omarchian; do
  if [[ -d "$(config_root)/$app" ]]; then
    link_config "$app"
  fi
done

# Seed a default theme symlink so configs referencing
# ~/.config/omarchian/current/theme resolve to something on first boot.
mkdir -p "$HOME/.config/omarchian/current"
ln -sfn "$OMARCHIAN_PATH/themes/omarchian-dark" "$HOME/.config/omarchian/current/theme"
success "Default theme (omarchian-dark) activated"

success "Configs linked"
