#!/bin/bash

EMOJI_DB="$HOME/.local/share/emoji/all_emojis.txt"

chosen=$(awk -F'\t' '{print $1 " " $4}' "$EMOJI_DB" | \
  fuzzel --dmenu --prompt="> Emoji: " | \
  awk '{print $1}')

[ -z "$chosen" ] && exit 0

echo -n "$chosen" | wl-copy
notify-send "Emoji скопирован" "$chosen"
