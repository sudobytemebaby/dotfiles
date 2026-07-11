#!/bin/bash
#
# screenshot.sh — capture helper shared by fuzzel and quickshell.
#
#   screenshot.sh             → interactive fuzzel menu
#   screenshot.sh <action>    → run action directly (used by quickshell)
#       action ∈ fullscreen | region | window | ocr
#
# Region/window/ocr use slurp; cancelling slurp (Esc) aborts cleanly.

SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOTS_DIR"

shot() {
  local OUTPUT="$SCREENSHOTS_DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
  local geom

  case "$1" in
    fullscreen)
      grim -t ppm - | satty --filename - --output-filename "$OUTPUT" --copy-command wl-copy
      ;;
    region)
      geom=$(slurp) || return 0
      [ -z "$geom" ] && return 0
      grim -t ppm -g "$geom" - | satty --filename - --output-filename "$OUTPUT" --copy-command wl-copy
      ;;
    window)
      geom=$(hyprctl clients -j | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp) || return 0
      [ -z "$geom" ] && return 0
      grim -t ppm -g "$geom" - | satty --filename - --output-filename "$OUTPUT" --copy-command wl-copy
      ;;
    ocr)
      geom=$(slurp) || return 0
      [ -z "$geom" ] && return 0
      grim -g "$geom" - | tesseract -l rus+eng stdin stdout | wl-copy
      notify-send "OCR" "Текст скопирован в буфер"
      ;;
    *)
      return 1
      ;;
  esac
}

# Direct mode: action passed as argument (e.g. from quickshell)
if [ -n "$1" ]; then
  shot "$1"
  exit $?
fi

# Interactive mode: fuzzel menu
choice=$(printf "󰍹  Fullscreen\n󰒆  Region\n󱂬  Window\n󰐳  OCR (region → clipboard)" | \
  fuzzel --dmenu --prompt="> Screenshot: " --lines=4)

[ -z "$choice" ] && exit 0

sleep 0.2

case "$choice" in
  *Fullscreen) shot fullscreen ;;
  *Region)     shot region ;;
  *Window)     shot window ;;
  *OCR*)       shot ocr ;;
esac
