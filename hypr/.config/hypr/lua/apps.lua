local ipc = "noctalia msg "
local homedir = os.getenv("HOME")
--local bin_dir = homedir .. "/.local/bin/"
local tuis_dir = homedir .. "/.local/bin/tuis/"
local menus_dir = homedir .. "/.local/bin/menus/"

return {
	-- core
	terminal = "footclient",
	browser = "zen-browser",
	file_explorer = "nautilus",
	color_picker = "hyprpicker -a",

	-- system tui menus
	yazi = tuis_dir .. "tui-files",
	system_monitor = tuis_dir .. "tui-btop",
	wifi_menu = tuis_dir .. "tui-wifi",
	bluetooth_menu = tuis_dir .. "tui-bluetooth",
	audio_menu = tuis_dir .. "tui-audio",

	-- ipc
	screenshot = ipc .. "screenshot",
	lockscreen = ipc .. "session lock",
	spotlight = "fuzzel",
	clipboard_picker = tuis_dir .. "clipboard.sh",
	emoji_picker = menus_dir .. "emoji-picker.sh",
	powermenu = ipc .. "powermenu toggle",
	wallpaper_picker = ipc .. "wallpaper toggle",

	-- volume / brightness / mic
	brightness_up = "brightnessctl set +5%",
	brightness_down = "brightnessctl set 5%-",

	input_up = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+",
	input_down = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-",
	input_mute = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",

	volume_up = "wpctl set-volume @DEFAULT_SINK@ 5%+",
	volume_down = "wpctl set-volume @DEFAULT_SINK@ 5%-",
	volume_mute = "wpctl set-mute @DEFAULT_SINK@ toggle",
}
