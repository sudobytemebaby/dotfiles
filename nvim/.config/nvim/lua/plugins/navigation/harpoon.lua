return {
	"ThePrimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>a", function() require("harpoon.mark").add_file() end,        desc = "Harpoon: Add File" },
		{ "<C-e>",     function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon: Menu" },
		{ "<C-q>",     function() require("harpoon.ui").nav_file(1) end,         desc = "Harpoon: File 1" },
		{ "<C-s>",     function() require("harpoon.ui").nav_file(2) end,         desc = "Harpoon: File 2" },
		{ "<C-r>",     function() require("harpoon.ui").nav_file(3) end,         desc = "Harpoon: File 3" },
		{ "<C-t>",     function() require("harpoon.ui").nav_file(4) end,         desc = "Harpoon: File 4" },
	},
}
