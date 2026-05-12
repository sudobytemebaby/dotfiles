-- Swipe horizontally with 3 fingers to switch workspaces
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- 3-finger down + SUPER closes the active window
hl.gesture({ fingers = 3, direction = "down", mod = "SUPER", action = "close" })

-- 3-finger up + SUPER toggles fullscreen
hl.gesture({ fingers = 3, direction = "up", mod = "SUPER", scale = 1.5, action = "fullscreen" })
