-- Leaders must be set before lazy loads so all plugin keymaps pick them up
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core")
require("lazy-setup")
