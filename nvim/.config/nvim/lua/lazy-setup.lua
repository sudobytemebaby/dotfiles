-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "plugins.treesitter" },
	{ import = "plugins" },
	{ import = "plugins.lsp" },
	{ import = "plugins.ui" },
	{ import = "plugins.navigation" },
}, {
	rocks = { enabled = false },
})
