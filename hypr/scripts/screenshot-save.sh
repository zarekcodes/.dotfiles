#!/usr/bin/env bash
# Select a region, then name and save it from a "Save As" dialog.
# Bound to SUPER + SHIFT + P. SUPER + P stays clipboard-only.
set -euo pipefail

command -v zenity >/dev/null || {
	notify-send "Screenshot" "zenity is not installed (sudo pacman -S zenity)"
	exit 1
}

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"

# Capture before the dialog opens so the dialog isn't in the shot.
region=$(slurp) || exit 0 # Esc cancels the selection
tmp=$(mktemp --suffix=.png)
trap 'rm -f "$tmp"' EXIT
grim -g "$region" "$tmp"

# Cancel in the dialog discards the shot.
dest=$(zenity --file-selection --save --title="Save screenshot" \
	--filename="$dir/screenshot-$(date +%F_%H-%M-%S).png") || exit 0
[[ $dest == *.png ]] || dest+=".png"

mv "$tmp" "$dest"
wl-copy --type image/png <"$dest"
notify-send -i "$dest" "Screenshot saved" "$dest"
