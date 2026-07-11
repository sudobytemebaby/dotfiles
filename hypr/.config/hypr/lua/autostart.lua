hl.on("hyprland.start", function()
	-- shell (quickshell renders the wallpaper itself — no hyprpaper needed)
	hl.exec_cmd("noctalia")
	hl.exec_cmd("hyprpolkitagent")
	hl.exec_cmd("hypridle")

	-- foot terminal server
	hl.exec_cmd("foot --server")

	-- clipboard history
	hl.exec_cmd("wl-paste --type text  --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("clipse -listen")

	-- housekeeping
	hl.exec_cmd("trash-empty 30")

	-- forward bluetooth media keys to MPRIS
	hl.exec_cmd("mpris-proxy")
end)
