lvim.leader = "space"
local which_key = lvim.builtin.which_key

-- Shorten function name
local keymap = function(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then options = vim.tbl_extend("force", options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
local wkeymappings = which_key.mappings

-- move lines
keymap("v", "<S-j>", ":m '>+1<CR>gv=gv")
keymap("v", "<S-k>", ":m '<-2<CR>gv=gv")

keymap("n", "K", "<nop>")
-- hop
local hop_ok = pcall(require, "hop")
if hop_ok then
    opts = { silent = true }
    keymap("n", "\\s", "<cmd>HopChar2<CR>", opts)
    keymap("n", "\\gs", "<cmd>HopChar2MW<CR>", opts)

    keymap("", "f",
        "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
        opts)
    keymap("", "F",
        "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
        opts)
    keymap("", "t",
        "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>",
        opts)
    keymap("", "T",
        "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = -1 })<cr>",
        opts)
    keymap("", "\\l", "<cmd>HopLine<CR>", opts)
    keymap("", "\\L", "<cmd>HopLineStart<CR>", opts)
    keymap("n", "\\gl", "<cmd>HopLineMW<CR>", opts)
    keymap("", "\\f", "<cmd>HopPattern<CR>", opts)
    keymap("n", "\\gf", "<cmd>HopPatternMW<CR>", opts)
    keymap("", "\\w", "<cmd>HopWord<CR>", opts)
    keymap("n", "\\gw", "<cmd>HopWordMW<CR>", opts)
end

-- local goto_preview_ok = pcall(require, "goto-preview")
-- if goto_preview_ok then
--     opts = { silent = true }
    -- keymap("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", opts)
    -- keymap("n", "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", opts)
    -- keymap("n", "gpc", "<cmd>lua require('goto-preview').close_all_win()<CR>", opts)
-- end

local trouble_ok = pcall(require, "trouble")
if trouble_ok then
    lvim.builtin.which_key.mappings["t"] = {
        name = "Diagnostics",
        t = { "<cmd>TroubleToggle<cr>", "trouble" },
        w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
        d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
        q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
        l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
        r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
   }
end

-- lspsaga
-- TODO: https://github.com/nvimdev/lspsaga.nvim config more from this site
local status_lspsaga_ok = pcall(require, "lspsaga")
if status_lspsaga_ok then
    keymap('n', '[e', ':Lspsaga diagnostic_jump_prev<CR>')
    keymap('n', ']e', ':Lspsaga diagnostic_jump_next<CR>')
    keymap('n', '[c', ':Lspsaga incoming_calls<CR>')
    keymap('n', ']c', ':Lspsaga outgoing_calls<CR>')
    keymap('n', 'K', ':Lspsaga hover_doc<CR>')
    keymap('n', 'gpd', ':Lspsaga peek_definition<CR>')
    keymap('n', 'gpt', ':Lspsaga peek_type_definition<CR>')
    keymap('n', 'gpi', ':Lspsaga Lspsaga finder imp<CR>')
    keymap('n', '\\t', ':Lspsaga term_toggle<CR>')
    keymap('n', '\\o', ':Lspsaga outline<CR>')
    -- removed
    -- https://github.com/glepnir/lspsaga.nvim/issues/502#issuecomment-1236949596
    -- keymap('i', '<C-k>', '<Cmd>Lspsaga signature_help<CR>')
    -- keymap('i', '<C-k>', ':lua vim.lsp.buf.signature_help()<CR>')
    -- wkeymappings['l'] = {
    --     D = { ':Lspsaga lsp_finder<cr>', 'LSP finder' },
    --     p = { ':Lspsaga peek_definition<cr>', 'Peek definition' },
    --     r = { ':Lspsaga rename<cr>', 'LSP rename' },
    --     o = { ':Lspsaga outline<cr>', 'LSP ouline' },
    --     a = { ':Lspsaga code_action<cr>', 'LSP code action' },
    -- }
end
