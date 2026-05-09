-- QML Language Server (part of Qt6)
-- Install: pacman -S qt6-declarative
-- Binary is typically at /usr/lib/qt6/bin/qmlls (may not be in PATH)
local qmlls_bin = vim.fn.exepath("qmlls")
if qmlls_bin == "" then
	qmlls_bin = "/usr/lib/qt6/bin/qmlls"
end

return {
	cmd = { qmlls_bin },
	filetypes = { "qml" },
	root_markers = { "qmlproject", ".git" },
}
