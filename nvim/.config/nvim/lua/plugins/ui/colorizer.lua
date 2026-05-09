-- NvChad/nvim-colorizer.lua is the maintained fork of norcalli/nvim-colorizer.lua
return {
	"NvChad/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		user_default_options = {
			tailwind = true,
			css = true,
		},
	},
}
