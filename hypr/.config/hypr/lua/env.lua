-- Toolkit backends
hl.env("GDK_BACKEND", "wayland,x11")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

hl.env("SDL_VIDEODRIVER", "wayland,x11,windows")
hl.env("CLUTTER_BACKEND", "wayland")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("ELECTRON_ENABLE_WAYLAND", "1")

-- XDG
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_DATA_DIRS", "/usr/local/share:/usr/share:/home/sudobytemebaby/.local/share")

-- GTK
hl.env("ADW_DISABLE_PORTAL", "1")
hl.env("GTK_THEME", "adw-gtk3")

-- Cursor
hl.env("HYPRCURSOR_THEME", "phinger-cursors-dark")
hl.env("XCURSOR_THEME", "phinger-cursors-dark")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE", "24")
