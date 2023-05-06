lvim.leader = "space"
local which_key = lvim.builtin.which_key

-- Shorten function name
local keymap = function(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
local wkeymappings = which_key.mappings

-- reset
keymap("n", "K", "<nop>")
keymap("n", "q", "<Nop>")
wkeymappings["c"] = nil
wkeymappings["p"] = nil
wkeymappings["l"] = nil
wkeymappings["L"] = nil
wkeymappings["s"] = {}
wkeymappings["S"] = {}
wkeymappings["S"] = {}

wkeymappings['f'] = { name = 'file, find' }
wkeymappings['g'] = { name = 'git, go' }
wkeymappings['v'] = { name = 'visual' }
wkeymappings['t'] = { name = 'trouble, todo' }
wkeymappings['\\'] = { name = 'hop, register' }


-- remap macro record key
keymap("n", "Q", "q")

-- remap undo
keymap("n", "U", "<C-S-r>")

-- insert 
keymap("i", "<C-enter>", "<esc>o")

-- delete
keymap("n", "d", '"_d')
keymap("v", "d", '"_d')

-- Cut, then can paste
keymap("n", "X", "dd")

-- better ^, move cursor to start of line
keymap("n", "<C-h>", "^")
keymap("i", "<C-h>", "<esc>^i")
keymap("v", "<C-h>", "^")
keymap("n", "<C-S-h>", "<Home>")
keymap("i", "<C-S-h>", "<Home>")
keymap("v", "<C-S-h>", "<Home>")

-- better $
keymap("n", "<C-l>", "<End>")
keymap("i", "<C-l>", "<End>")
keymap("v", "<C-l>", "<End><Left>")

-- Resize window
keymap("n", "<C-left>", "<C-w><")
keymap("n", "<C-right>", "<C-w>>")
keymap("n", "<C-up>", "<C-w>-")
keymap("n", "<C-down>", "<C-w>+")

-- fast to move
keymap("n", "<C-j>", "5j")
keymap("n", "<C-k>", "5k")

keymap("v", "<C-j>", "5j")
keymap("v", "<C-k>", "5k")
-- move lines
keymap("v", "<S-j>", ":m '>+1<CR>gv=gv")
keymap("v", "<S-k>", ":m '<-2<CR>gv=gv")

------------------------------------------ Plugin ------------------------------------------
-- bufferline
keymap('n', '<s-tab>', ':BufferLineCyclePrev<CR>')
keymap('n', '<tab>', ':BufferLineCycleNext<CR>')

--  nvim-tree
wkeymappings['e'] = { ':NvimTreeToggle<CR>', 'File explorer' }
wkeymappings['o'] = { ':NvimTreeFocus<CR>', 'File explorer locate file' }

-- telescope
wkeymappings['f']['f'] = { ':Telescope find_files<cr>', 'Find Files' }
wkeymappings['f']['o'] = { ':Telescope oldfiles<cr>', 'Find Old Files' }
wkeymappings['f']['b'] = { ':Telescope buffers<cr>', 'Find Buffers' }
wkeymappings['f']['h'] = { ':Telescope help_tags<cr>', 'Find Help' }
wkeymappings['f']['w'] = { ':Telescope live_grep<cr>', 'Live Grep' }
wkeymappings['f']['c'] = { ":Telescope git_status<cr>", "Open changed file" }
wkeymappings['f']['P'] = { ":Telescope projects<CR>", "Projects" }

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

-- trouble
local trouble_ok = pcall(require, "trouble")
if trouble_ok then
  wkeymappings['t']['r'] = {
    name = "+Trouble",
    r = { "<cmd>Trouble lsp_references<cr>", "References" },
    f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
    d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
    q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
    l = { "<cmd>Trouble loclist<cr>", "LocationList" },
    w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
    t = { "<cmd>TodoTrouble<cr>", "Todo" }
  }
end

-- diffview
lvim.builtin.which_key.mappings["gd"] = { "<cmd>DiffviewOpen<cr>", "diffview: diff HEAD" }
lvim.builtin.which_key.mappings["gh"] = { "<cmd>DiffviewFileHistory<cr>", "diffview: filehistory" }

-- todo-comments
-- local todo_ok = pcall(require, "todo-comments")
-- wkeymappings['t']['t'] = { name = '+todo comments' }
-- if todo_ok then
--   local cmd = ':TodoLocList<cr>'
--   if trouble_ok then
--     cmd = ':TodoTrouble<cr>'
--   end
--   wkeymappings['f']['t']['c'] = { cmd, 'Todos' }
-- else
-- end

-- gitsigns
local status_gitsigns_ok = pcall(require, "gitsigns")
if status_gitsigns_ok then
  wkeymappings['g']['s'] = {
    name = 'Gitsigns',
    j = { ":lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
    k = { ":lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
    l = { ":lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    p = { ":lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { ":lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { ":lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { ":lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    S = { ":lua require 'gitsigns'.stage_buffer()<cr>", "Stage Buffer" },
    u = { ":lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
    d = { ":Gitsigns diffthis HEAD<cr>", "Git Diff" },
  }
end

-- hop
local hop_ok = pcall(require, "hop")
if hop_ok then
  opts = { silent = true }
  keymap("n", "\\s", ":HopChar2<CR>", { silent = true })
  keymap("n", "\\gs", ":HopWordMW<CR>", { silent = true })
  
  keymap("n", "f", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", opts)
  keymap("n", "F", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", opts)
  keymap("v", "f", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", opts)
  keymap("v", "F", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", opts)
  keymap("", "t", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", opts)
  keymap("", "T", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", opts)
  keymap("", "\\l", ":HopLine<CR>", opts)
  keymap("", "\\L", ":HopLineStart<CR>", opts)
  keymap("", "\\gl", ":HopLineMW<CR>", opts)
  keymap("n", "\\f", ":HopPattern<CR>", opts)
  keymap("n", "\\gf", ":HopPatternMW<CR>", opts)
  keymap("n", "\\w", ":HopWord<CR>", opts)
  keymap("n", "\\gw", ":HopWordMW<CR>", opts)
  keymap("n", "\\v", ":HopVertical<CR>", opts)
  keymap("n", "\\gv", ":HopVerticalMW<CR>", opts)
end

-- nvim-spectre
local status_nvim_spectre_ok = pcall(require, 'spectre')
if (status_nvim_spectre_ok) then
  wkeymappings['s']['v'] = { ':lua require("spectre").open_visual()<cr>', 'Find text' }
  wkeymappings['s']['p'] = { ':lua require("spectre").open_file_search()<cr>', 'Find text current file path' }
end

-- map to global
require("which-key").register({
  f = wkeymappings['f'],
  g = wkeymappings['g'],
  s = wkeymappings['s'],
})
