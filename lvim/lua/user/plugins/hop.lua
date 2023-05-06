local M = {}

M.config = function()
  local status_ok, hop = pcall(require, "hop")
  if not status_ok then
    return
  end

  opts = { silent = true }

  hop.setup()
  vim.api.nvim_set_keymap("n", "\\s", ":HopChar2<CR>", { silent = true })
  vim.api.nvim_set_keymap("n", "\\gs", ":HopWord<CR>", { silent = true })
  
  vim.api.nvim_set_keymap("n", "f", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", opts)
  vim.api.nvim_set_keymap("n", "F", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", opts)
  vim.api.nvim_set_keymap("v", "f", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", opts)
  vim.api.nvim_set_keymap("v", "F", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", opts)
  vim.api.nvim_set_keymap("", "t", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", opts)
  vim.api.nvim_set_keymap("", "T", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", opts)

  
  vim.api.nvim_set_keymap("n", "\\l", ":HopLine<CR>", opts)
  vim.api.nvim_set_keymap("n", "\\L", ":HopLineStart<CR>", opts)
  vim.api.nvim_set_keymap("n", "\\gl", ":HopLineMW<CR>", opts)


  vim.api.nvim_set_keymap("n", "\\f", ":HopPattern<CR>", opts)
  vim.api.nvim_set_keymap("n", "\\gf", ":HopPatternMW<CR>", opts)

  vim.api.nvim_set_keymap("n", "\\w", ":HopWord<CR>", opts)
  vim.api.nvim_set_keymap("n", "\\gw", ":HopWordMW<CR>", opts)

  vim.api.nvim_set_keymap("n", "\\v", ":HopVertical<CR>", opts)
  vim.api.nvim_set_keymap("n", "\\gv", ":HopVerticalMW<CR>", opts)

end

return M
