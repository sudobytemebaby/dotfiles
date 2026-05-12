local c = require("lua.colors")

hl.config({
	general = {
		layout = "dwindle",
		border_size = 2,
		gaps_in = 4,
		gaps_out = 6,

		col = {
			active_border = c.border,
			inactive_border = c.border_dim,
		},
	},

	decoration = {
		rounding = 4,

		blur = {
			enabled = true,
			size = 20,
			passes = 3,
			new_optimizations = true,
			xray = false,
			ignore_opacity = true,
			brightness = 0.8,
			contrast = 1.0,
			noise = 0.05,
			vibrancy = 0.2,
			vibrancy_darkness = 0.4,
		},

		shadow = {
			enabled = true,
			range = 20,
			render_power = 2,
			offset = "1 2",
			scale = 3,
			color = "rgba(00000080)",
		},
	},

	dwindle = {
		preserve_split = true,
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
		allow_session_lock_restore = true,
		middle_click_paste = false,
		focus_on_activate = true,
		session_lock_xray = true,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
	},

	input = {
		kb_layout = "us,ru",
		kb_options = "grp:caps_toggle",
		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = true,
		},
	},

	xwayland = {
		force_zero_scaling = true,
	},
})
