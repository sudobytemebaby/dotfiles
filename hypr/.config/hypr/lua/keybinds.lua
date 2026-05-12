local a = require("lua.apps")

local mod = "SUPER"
local mods = "SUPER + SHIFT"

----------------------------------------------------------------------
-- Launchers & apps
----------------------------------------------------------------------
hl.bind(mod .. " + Space", hl.dsp.exec_cmd(a.spotlight))
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(a.terminal))
hl.bind(mod .. " + B", hl.dsp.exec_cmd(a.browser))
hl.bind(mod .. " + N", hl.dsp.exec_cmd(a.file_explorer))
hl.bind(mod .. " + Y", hl.dsp.exec_cmd(a.yazi))
hl.bind(mod .. " + M", hl.dsp.exec_cmd(a.system_monitor))

hl.bind(mod .. " + Comma", hl.dsp.exec_cmd(a.clipboard_picker))
hl.bind(mod .. " + Period", hl.dsp.exec_cmd(a.emoji_picker))
hl.bind(mod .. " + W", hl.dsp.exec_cmd(a.wallpaper_picker))
hl.bind(mod .. " + P", hl.dsp.exec_cmd(a.powermenu))

----------------------------------------------------------------------
-- Screenshots / system pickers (Super+Shift)
----------------------------------------------------------------------
hl.bind("Print", hl.dsp.exec_cmd(a.screenshot))

hl.bind(mods .. " + L", hl.dsp.exec_cmd(a.lockscreen))
hl.bind(mods .. " + P", hl.dsp.exec_cmd(a.color_picker))
hl.bind(mods .. " + W", hl.dsp.exec_cmd(a.wifi_menu))
hl.bind(mods .. " + B", hl.dsp.exec_cmd(a.bluetooth_menu))
hl.bind(mods .. " + A", hl.dsp.exec_cmd(a.audio_menu))

----------------------------------------------------------------------
-- Media / volume / brightness (locked + repeating so they work on lockscreen)
----------------------------------------------------------------------
local repeating = { locked = true, repeating = true }
local locked = { locked = true }

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(a.brightness_up), repeating)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(a.brightness_down), repeating)

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(a.volume_up), repeating)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(a.volume_down), repeating)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(a.volume_mute), locked)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(a.input_mute))

----------------------------------------------------------------------
-- Window management
----------------------------------------------------------------------
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mods .. " + E", hl.dsp.exit())

----------------------------------------------------------------------
-- Focus (arrows + vim hjkl)
----------------------------------------------------------------------
local directions = {
	{ "left", "H" },
	{ "right", "L" },
	{ "up", "K" },
	{ "down", "J" },
}
for _, d in ipairs(directions) do
	local dir, vim_key = d[1], d[2]
	hl.bind(mod .. " + " .. dir, hl.dsp.focus({ direction = dir }))
	hl.bind(mod .. " + " .. vim_key, hl.dsp.focus({ direction = dir }))
end

----------------------------------------------------------------------
-- Resize active window (Super+Shift + arrows)
----------------------------------------------------------------------
hl.bind(mods .. " + left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }))
hl.bind(mods .. " + right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }))
hl.bind(mods .. " + up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }))
hl.bind(mods .. " + down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }))

----------------------------------------------------------------------
-- Workspaces (Super+N: focus, Super+Shift+N: move window) — key 0 = ws 10
----------------------------------------------------------------------
for i = 1, 10 do
	local key = i % 10
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mods .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through workspaces (relative)
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

----------------------------------------------------------------------
-- Mouse drag/resize
----------------------------------------------------------------------
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mods .. " + mouse:272", hl.dsp.window.resize(), { mouse = true })
