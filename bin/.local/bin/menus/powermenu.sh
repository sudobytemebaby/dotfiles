#!/bin/bash

choice=$(printf "  Shutdown\n  Reboot\n  Lock Screen\n󰽥  Suspend\n  Logout" | fuzzel --dmenu --prompt="Power: " --lines=5)

case "$choice" in
    *"Shutdown"*) systemctl poweroff ;;
    *"Reboot"*)   systemctl reboot ;;
    *"Lock Screen"*) hyprlock ;;
    *"Suspend"*)  systemctl suspend ;;
    *"Logout"*)   hyprctl terminate-session ;;
esac
