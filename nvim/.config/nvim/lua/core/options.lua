local opt = vim.opt

-- Numbers
opt.nu = true
opt.relativenumber = true

-- Indentation: 2-space soft tabs
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.wrap = false

-- No swap or backup files; persistent undo instead
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("state") .. "/undo"
opt.undofile = true

-- Search
opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

-- Keep cursor away from screen edges when scrolling
opt.scrolloff = 8

-- Reserve sign column so layout doesn't jump when LSP/git signs appear
opt.signcolumn = "yes"

-- Faster CursorHold (used by LSP, gitsigns, etc.)
opt.updatetime = 50

opt.colorcolumn = "0"
