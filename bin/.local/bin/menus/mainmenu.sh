#!/bin/bash

choice=$(printf "󰂯  Bluetooth\n󰤨  WiFi\n󰉋  Files\n󰍛  System Monitor\n󰅇  Clipboard\n󰕾  Audio\n󰁹  Battery\n󰀻  Applications\n󰹑  Screenshot\n󰐥  Power Menu\n󰞅  Emoji Picker" | \
  fuzzel --dmenu --prompt="> " --lines=11)

[ -z "$choice" ] && exit 0

case "$choice" in
  *Bluetooth)      ~/.local/bin/tuis/tui-bluetooth ;;
  *WiFi)           ~/.local/bin/tuis/tui-wifi ;;
  *Files)          ~/.local/bin/tuis/tui-files ;;
  *"System Monitor") ~/.local/bin/tuis/tui-btop ;;
  *Clipboard)      ~/.local/bin/tuis/tui-clipboard ;;
  *Audio)          ~/.local/bin/tuis/tui-audio ;;
  *Battery)        ~/.local/bin/tuis/tui-battery ;;
  *Applications)   fuzzel ;;
  *Screenshot)     ~/.local/bin/menus/screenshot.sh ;;
  *"Power Menu")   ~/.local/bin/menus/powermenu.sh ;;
  *"Emoji Picker") ~/.local/bin/menus/emoji-picker.sh ;;
esac
