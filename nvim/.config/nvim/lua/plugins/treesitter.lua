-- nvim-treesitter `main` branch: parsers are installed explicitly,
-- and highlighting is started per-buffer via vim.treesitter.start().
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			-- Filetype -> parser name. They match for most languages; exceptions
			-- like typescriptreact->tsx and qml->qmljs are listed explicitly.
			local filetype_to_parser = {
				lua = "lua",
				javascript = "javascript",
				typescript = "typescript",
				typescriptreact = "tsx",
				html = "html",
				css = "css",
				json = "json",
				yaml = "yaml",
				markdown = "markdown",
				go = "go",
				rust = "rust",
				python = "python",
				qml = "qmljs",
			}

			-- Parsers to install. `markdown_inline` has no filetype of its own
			-- but is required for proper highlighting inside markdown.
			local parsers = vim.tbl_values(filetype_to_parser)
			table.insert(parsers, "markdown_inline")

			require("nvim-treesitter").setup({})
			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = vim.tbl_keys(filetype_to_parser),
				callback = function(args)
					local parser = filetype_to_parser[vim.bo[args.buf].filetype]
					pcall(vim.treesitter.start, args.buf, parser)
				end,
			})
		end,
	},
}
