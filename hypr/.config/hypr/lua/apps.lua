local ipc = "qs -c noctalia-shell ipc call"
local homedir = os.getenv("HOME")
local bin_dir = homedir .. "/.local/bin/"

return {
	-- core
	terminal = "footclient",
	browser = "zen-browser",
	file_explorer = "nautilus",
	color_picker = "hyprpicker -a",
	yazi = bin_dir .. "tui-files",
	system_monitor = bin_dir .. "tui-btop",

	-- system tui menus
	wifi_menu = bin_dir .. "tui-wifi",
	bluetooth_menu = bin_dir .. "tui-bluetooth",
	audio_menu = bin_dir .. "tui-audio",

	-- noctalia ipc
	screenshot = ipc .. " plugin:quick-screenshot menu",
	lockscreen = ipc .. " lockScreen lock",
	spotlight = ipc .. " launcher toggle",
	clipboard_picker = ipc .. " launcher clipboard",
	emoji_picker = ipc .. " launcher emoji",
	powermenu = ipc .. " sessionMenu toggle",
	wallpaper_picker = ipc .. " wallpaper toggle",

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
