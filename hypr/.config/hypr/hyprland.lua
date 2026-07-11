-- Monitor
hl.monitor({
	output = "eDP-1",
	mode = "2880x1800@120.00Hz",
	position = "0x0",
	scale = 2,
})

-- Modules. Order matters: settings reads colors, keybinds reads apps.
require("lua.env")
require("lua.autostart")
require("lua.settings")
require("lua.animations")
require("lua.rules")
require("lua.gestures")
require("lua.keybinds")
