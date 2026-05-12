-- Foot terminal: dim opacity for both server and client classes
hl.window_rule({
	name = "foot-opacity",
	match = { class = "^foot$" },
	opacity = "0.8 override 0.8 override",
})
hl.window_rule({
	name = "footclient-opacity",
	match = { class = "^footclient$" },
	opacity = "0.8 override 0.8 override",
})

-- Floating dialogs / picker apps
local function floating_dialog(name, match, w, h)
	hl.window_rule({
		name = name,
		match = match,
		float = true,
		center = true,
		size = { w, h },
	})
end

floating_dialog("satty-annotation", { class = "^com.gabm.satty$" }, 1100, 700)
floating_dialog("xdg-gtk-file-picker", { class = "^xdg-desktop-portal-gtk$" }, 900, 700)
floating_dialog("file-upload-dialog", { title = "^File Upload$" }, 900, 700)
floating_dialog("open-file-dialog", { title = "^Open File$" }, 900, 700)
floating_dialog("save-as-dialog", { title = "^Save As$" }, 900, 700)
floating_dialog("save-file-dialog", { title = "^Save File$" }, 900, 700)
floating_dialog("calculator", { class = "^org.gnome.Calculator$" }, 460, 550)
floating_dialog("translator", { class = "^app.drey.Dialect$" }, 500, 550)

-- Floating terminal sizes (footclient --app-id floating_term_<s|m|l|xl>)
local function floating_term(size_name, w, h)
	hl.window_rule({
		name = "floating-term-" .. size_name,
		match = { class = "^floating_term_" .. size_name .. "$" },
		float = true,
		center = true,
		opacity = "0.8 override 0.8 override",
		size = { w, h },
	})
end

floating_term("s", 800, 600)
floating_term("m", 900, 700)
floating_term("l", 1200, 800)
floating_term("xl", 1340, 800)

hl.layer_rule({
	name = "noctalia-region-selector-no-anim",
	match = { namespace = "noctalia-shell:regionSelector" },
	no_anim = true,
})
