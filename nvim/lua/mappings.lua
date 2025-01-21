require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

--- Common
map("i", "jj", "<Esc>")
map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("n", "gb", "<C-o>", { desc = "jump jump back" })

--- Common mappings with `Ctrl` used in other apps
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "file save" })
map({ "n", "i", "v" }, "<C-z>", "<cmd> undo <cr>", { desc = "history undo" })
map({ "n", "i", "v" }, "<C-y>", "<cmd> redo <cr>", { desc = "history redo" })
map("n", "<C-_>", "gcc", { desc = "comment toggle", remap = true })
map("i", "<C-_>", "<Esc>gcc^i", { desc = "comment toggle", remap = true })
map("v", "<C-_>", "gc", { desc = "comment toggle", remap = true })

map({ "n", "i", "v" }, "<C-f>", function()
  if vim.bo.filetype == "TelescopePrompt" then
    vim.cmd "q!"
  else
    vim.cmd "Telescope current_buffer_fuzzy_find"
  end
end, { desc = "search search in current buffer" })
map({ "n", "i", "v" }, "<A-f>", function()
  if vim.bo.filetype == "TelescopePrompt" then
    vim.cmd "q!"
  else
    vim.cmd "Telescope live_grep"
  end
end, { desc = "search search across project" })

--- Terminal comment here
map({ "n", "i", "v", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggle vertical term" })
map({ "n", "i", "v", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggle horizontal term" })
map({ "n", "i", "v", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

--- LSP
map("n", "gh", "<cmd> lua vim.lsp.buf.hover() <cr>", { desc = "LSP hover" })
map("n", "ge", "<cmd> lua vim.diagnostic.open_float() <cr>", { desc = "LSP show diagnostics" })
map({ "n", "i", "v" }, "<A-.>", "<cmd> lua vim.lsp.buf.code_action() <cr>", { desc = "LSP code action" })
map({ "n", "i", "v" }, "<F2>", function()
  if vim.bo.filetype == "NvimTree" then
    require("nvim-tree.api").fs.rename()
  else
    require "nvchad.lsp.renamer"()
  end
end, { desc = "LSP rename" })
map({ "n", "i", "v" }, "<F12>", "<cmd> lua vim.lsp.buf.definition() <cr>", { desc = "LSP rename" })


-- Motions here, use plugin hadronized/hop.nvim.
local hop = require('hop')
local directions = require('hop.hint').HintDirection

map({ "n", "v" }, "f", function ()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { remap = true, desc = "VIM f: after cursor in current line." })

map({ "n", "v" }, "F", function ()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { remap = true, desc = "VIM F: before cursor in current line." })

map({ "n", "v" }, "t", function ()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, { remap = true, desc = "VIM f: after cursor in current line." })

map({ "n", "v" }, "T", function ()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = -1 })
end, { remap = true, desc = "VIM F: before cursor in current line." })

map({ "n", "v" }, "\\w", function ()
  hop.hint_words()
end, { remap = true, desc = "Move to begin of word you select." })

map({ "n", "v" }, "\\s", function ()
  hop.hint_char2()
end, { remap = true, desc = "Move to 2 chars you input." })

map({ "n", "v" }, "\\l", function ()
  require'hop'.hint_lines()
end, { remap = true, desc = "Move to the start line you select." })

-- goto-preview mapping config here, use plugin rmagatti/goto-preview
local goto_preview = require('goto-preview')

map({ "n" }, "gpd", function ()
  goto_preview.goto_preview_definition()
end, { remap = true, desc = "Go to preview definition." })

map({ "n" }, "gpt", function ()
  goto_preview.goto_preview_type_definition()
end, { remap = true, desc = "Go to preview type definition." })

map({ "n" }, "gpi", function ()
  goto_preview.goto_preview_implementation()
end, { remap = true, desc = "Go to preview implementation." })

map({ "n" }, "gpD", function ()
  goto_preview.goto_preview_declaration()
end, { remap = true, desc = "Go to preview declaration." })

map({ "n" }, "gpc", function ()
  goto_preview.close_all_win()
end, { remap = true, desc = "Close all float windows for goto-preview." })

map({ "n" }, "gpr", function ()
  goto_preview.goto_preview_references()
end, { remap = true, desc = "Go to preview references." })

