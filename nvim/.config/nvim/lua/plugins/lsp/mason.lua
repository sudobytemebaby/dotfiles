-- LSP servers installed via mason. Per-server settings live in after/lsp/<name>.lua
local mason_servers = {
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
}

-- Servers using a system install (not managed by mason)
local external_servers = {
	"qmlls", -- ships with qt6-declarative
}

local tools = {
	"prettier",
	"stylua",
	"eslint_d",

	"gofumpt",
	"goimports-reviser",
	"golines",

	"yamllint",
	"yamlfmt",
}

return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
				border = "rounded",
			},
		})

		require("mason-lspconfig").setup({
			ensure_installed = mason_servers,
		})

		require("mason-tool-installer").setup({
			ensure_installed = tools,
		})

		local servers = vim.list_extend(vim.deepcopy(mason_servers), external_servers)
		vim.lsp.enable(servers)
	end,
}
