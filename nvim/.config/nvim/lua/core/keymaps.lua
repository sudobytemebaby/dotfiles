local map = vim.keymap.set

-- Move highlighted lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Half-page jumps keep the cursor centered
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up (centered)" })

-- Yank to system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Escape from insert mode without leaving home row
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Disable Ex mode
map("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- Replace all occurrences of word under cursor
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- chmod +x current file
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- Open parent directory with oil.nvim
map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })

-- Toggle LSP inlay hints
map("n", "<leader>h", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })
