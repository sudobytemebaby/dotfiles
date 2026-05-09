return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local parsers = {
				"lua",
				"javascript",
				"typescript",
				"tsx",
				"html",
				"css",
				"json",
				"yaml",
				"markdown",
				"markdown_inline",
				"go",
				"rust",
				"python",
				"qmljs",
			}

			require("nvim-treesitter").setup({})
			require("nvim-treesitter").install(parsers)

			-- Enable treesitter highlighting per filetype
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"lua", "javascript", "typescript", "typescriptreact",
					"html", "css", "json", "yaml", "markdown",
					"go", "rust", "python",
				},
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})

			-- qmljs parser name differs from "qml" filetype, must be explicit
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "qml",
				callback = function(args)
					pcall(vim.treesitter.start, args.buf, "qmljs")
				end,
			})
		end,
	},
}
