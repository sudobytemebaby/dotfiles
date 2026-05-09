return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
				border = "rounded",
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"lua_ls",
				"emmet_ls",
				"tailwindcss",
				"gopls",
				"rust_analyzer",
				"pyright",
				"yamlls",
			},
			automatic_installation = true,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"eslint_d",

				"gofumpt",
				"goimports-reviser",
				"golines",

				"yamllint",
				"yamlfmt",
			},
		})

		-- Enable LSP servers (configs live in after/lsp/<server>.lua)
		vim.lsp.enable({
			"ts_ls",
			"html",
			"cssls",
			"lua_ls",
			"emmet_ls",
			"tailwindcss",
			"gopls",
			"rust_analyzer",
			"pyright",
			"yamlls",
			"qmlls", -- not mason-managed, uses system Qt6 install
		})
	end,
}
