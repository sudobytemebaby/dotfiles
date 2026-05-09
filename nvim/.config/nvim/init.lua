-- Leader must be set before lazy loads so all plugin keymaps pick it up
vim.g.mapleader = " "

require("core")
require("lsp")
require("lazy-setup")
