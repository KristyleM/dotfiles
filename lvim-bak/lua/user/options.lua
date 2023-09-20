vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.shell = "zsh"
vim.opt.relativenumber = false
vim.opt.colorcolumn = "120"
vim.opt.timeoutlen = 300
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.whichwrap = "<,>,[,]"
-- disable . \n to replace space and tldr
-- vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"


lvim.log.level = "warn"
lvim.format_on_save = {
  enabled = true,
  pattern = "*.lua",
  timeout = 1000,
}


