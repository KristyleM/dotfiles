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

-- lsp
lvim.keys.normal_mode["<leader>ld"] = ":lua vim.diagnostic.open_float()<CR>"
lvim.keys.normal_mode["<leader>lf"] = ":lua vim.lsp.buf.format({ async = true })<CR>"
lvim.keys.visual_mode["<leader>lf"] = ":lua vim.lsp.buf.format({silent = true, buffer = 0, normal = true})<CR>"
lvim.builtin.which_key.mappings["lo"] = { "<cmd>SymbolsOutline<CR>", "Symbols Outline" }

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
-- keymap("n", "<C-j>", "5j")
-- keymap("n", "<C-k>", "5k")

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
wkeymappings['f'] = {
  name = "Find file",
  f = { ':Telescope find_files<cr>', 'Find Files' },
  o = { ':Telescope oldfiles<cr>', 'Find Old Files' },
  b = { ':Telescope buffers<cr>', 'Find Buffers' },
  h = { ':Telescope help_tags<cr>', 'Find Help' },
  w = { ':Telescope live_grep<cr>', 'Live Grep' },
  c = { ":Telescope git_status<cr>", "Open changed file" },
  p = { ":Telescope projects<CR>", "Projects" },
}

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
local todo_ok = pcall(require, "todo-comments")
wkeymappings['t']['t'] = { name = '+todo comments' }
if todo_ok then
  local cmd = ':TodoLocList<cr>'
  if trouble_ok then
    cmd = ':TodoTrouble<cr>'
  end
  wkeymappings['t']['t']['c'] = { cmd, 'Todos' }
else
end

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
  wkeymappings['s'] = {
    name = "Spectre",
    v = { ':lua require("spectre").open_visual()<cr>', 'Find text' },
    p = { ':lua require("spectre").open_file_search({select_word=true})<cr>', 'Find text current file path' },
    s = { "<cmd>lua require('spectre').open()<CR>", "Open Spectre" },
    w = { "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Search current word" },
  }

end

-- nvim-surround-ui
local surround_ok, surround = pcall(require, 'surround-ui')
if surround_ok then
  surround.setup {
    root_key = 's'
  }
end

-- lspsaga
-- TODO: https://github.com/nvimdev/lspsaga.nvim config more from this site
local status_lspsaga_ok = pcall(require, "lspsaga")
if status_lspsaga_ok then
  keymap('n', '[e', ':Lspsaga diagnostic_jump_prev<CR>')
  keymap('n', ']e', ':Lspsaga diagnostic_jump_next<CR>')
  keymap('n', '<C-k>', ':Lspsaga hover_doc ++quiet<CR>')
  -- removed
  -- https://github.com/glepnir/lspsaga.nvim/issues/502#issuecomment-1236949596
  -- keymap('i', '<C-k>', '<Cmd>Lspsaga signature_help<CR>')
  -- keymap('i', '<C-k>', ':lua vim.lsp.buf.signature_help()<CR>')
  wkeymappings['l'] = {
    D = { ':Lspsaga lsp_finder<cr>', 'LSP finder' },
    p = { ':Lspsaga peek_definition<cr>', 'Peek definition' },
    r = { ':Lspsaga rename<cr>', 'LSP rename' },
    -- O = { ':Lspsaga outline<cr>', 'LSP ouline' },
    a = { ':Lspsaga code_action<cr>', 'LSP code action' },
  }
end

-- visual-multi
-- https://github.com/mg979/vim-visual-multi/wiki/Mappings#full-mappings-list
vim.cmd([[
  let g:VM_default_mappings = 0
  let g:VM_maps = {}
  let g:VM_maps["Find Under"] = ''
  let g:VM_maps["Find Subword Under"] = ''
]])
wkeymappings['v']['d'] = { '<Plug>(VM-Find-Under)', 'select multi word, `n` next' }
wkeymappings['v']['c'] = { '<Plug>(VM-Add-Cursor-At-Pos)', 'add cursor' }
wkeymappings['v']['j'] = { '<Plug>(VM-Add-Cursor-Down)', 'add cursor down' }
wkeymappings['v']['k'] = { '<Plug>(VM-Add-Cursor-Up)', 'add cursor up' }

-------------------------------------- language keybindings-------------------------------------
-- Rust
wkeymappings['r'] = {
  name = "Rust",
  r = { "<cmd>RustRunnables<Cr>", "Runnables" },
  t = { "<cmd>lua _CARGO_TEST()<cr>", "Cargo Test" },
  m = { "<cmd>RustExpandMacro<Cr>", "Expand Macro" },
  c = { "<cmd>RustOpenCargo<Cr>", "Open Cargo" },
  p = { "<cmd>RustParentModule<Cr>", "Parent Module" },
  d = { "<cmd>RustDebuggables<Cr>", "Debuggables" },
  v = { "<cmd>RustViewCrateGraph<Cr>", "View Crate Graph" },
  R = { "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<Cr>", "Reload Workspace" },
  o = { "<cmd>RustOpenExternalDocs<Cr>", "Open External Docs" },
  y = { "<cmd>lua require'crates'.open_repository()<cr>", "[crates] open repository" },
  P = { "<cmd>lua require'crates'.show_popup()<cr>", "[crates] show popup" },
  i = { "<cmd>lua require'crates'.show_crate_popup()<cr>", "[crates] show info" },
  f = { "<cmd>lua require'crates'.show_features_popup()<cr>", "[crates] show features" },
  D = { "<cmd>lua require'crates'.show_dependencies_popup()<cr>", "[crates] show dependencies" },
}

-- Python
-- NOTE: the following keybinds are wrapped in an filetype autocommand so they are only active in python files
-- you could also add the code in the callback function to lvim/ftplugin/python.lua
wkeymappings['p'] = {
  name = "Python",
  d = {
    name = "Debug",
    m = { "<cmd>lua require('neotest').run.run()<cr>", "Test Method" },
    M = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Test Method DAP" },
    f = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test Class" },
    F = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test Class DAP", },
    S = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" },
    V = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
  }
}

lvim.builtin.which_key.vmappings["d"] = {
  name = "Debug",
  s = { "<cmd>lua require('dap-python').debug_selection()<cr>", "Debug Selection" },
}

-- map to global
-- require("which-key").register({
--   f = wkeymappings['f'],
--   g = wkeymappings['g'],
--   s = wkeymappings['s'],
-- })
