-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

-----------------
-- Normal mode --
-----------------

-- Hint: see `:h vim.map.set()`
-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Move selected lines up/down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", opts)
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", opts)

-----------------
-- Diagnostics --
-----------------

-- Jump to previous/next error
vim.keymap.set('n', '[e', function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { noremap = true, silent = true, desc = "Previous error" })

vim.keymap.set('n', ']e', function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { noremap = true, silent = true, desc = "Next error" })

-- Jump to previous/next buffer
vim.keymap.set('n', '[b', ':bprevious<CR>', { noremap = true, silent = true, desc = "Previous buffer" })
vim.keymap.set('n', ']b', ':bnext<CR>', { noremap = true, silent = true, desc = "Next buffer" })

-- Jump to previous/next diagnostic (any severity)
vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump({ count = -1 })
end, { noremap = true, silent = true, desc = "Previous diagnostic" })

vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump({ count = 1 })
end, { noremap = true, silent = true, desc = "Next diagnostic" })

-- Jump to previous/next warning
vim.keymap.set('n', '[w', function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN })
end, { noremap = true, silent = true, desc = "Previous warning" })

vim.keymap.set('n', ']w', function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
end, { noremap = true, silent = true, desc = "Next warning" })

-- Jump to previous/next quickfix item
vim.keymap.set('n', '[q', ':cprevious<CR>', { noremap = true, silent = true, desc = "Previous quickfix" })
vim.keymap.set('n', ']q', ':cnext<CR>', { noremap = true, silent = true, desc = "Next quickfix" })

-- Jump to previous/next location list item
vim.keymap.set('n', '[l', ':lprevious<CR>', { noremap = true, silent = true, desc = "Previous location" })
vim.keymap.set('n', ']l', ':lnext<CR>', { noremap = true, silent = true, desc = "Next location" })

-- Jump to previous/next tab
vim.keymap.set('n', '[t', ':tabprevious<CR>', { noremap = true, silent = true, desc = "Previous tab" })
vim.keymap.set('n', ']t', ':tabnext<CR>', { noremap = true, silent = true, desc = "Next tab" })

-- Jump to previous/next spelling error
vim.keymap.set('n', '[s', '[s', { noremap = true, silent = true, desc = "Previous spelling error" })
vim.keymap.set('n', ']s', ']s', { noremap = true, silent = true, desc = "Next spelling error" })

-- Jump to last edited file position (remap `0 to ``)
vim.keymap.set('n', '``', '`0', { noremap = true, silent = true, desc = "Jump to last edited file" })

-- Paste over selection without yanking the replaced text
vim.keymap.set('v', 'p', '"_dP', { noremap = true, silent = true, desc = "Paste without yanking" })

-----------------
-- Insert mode --
-----------------

-- Move cursor in insert mode
vim.keymap.set('i', '<C-h>', '<Left>', { noremap = true, silent = true, desc = "Move left" })
vim.keymap.set('i', '<C-j>', '<Down>', { noremap = true, silent = true, desc = "Move down" })
vim.keymap.set('i', '<C-k>', '<Up>', { noremap = true, silent = true, desc = "Move up" })
vim.keymap.set('i', '<C-l>', '<Right>', { noremap = true, silent = true, desc = "Move right" })
vim.keymap.set('i', '<C-a>', '<C-o>^', { noremap = true, silent = true, desc = "Move to first non-blank" })
vim.keymap.set('i', '<C-e>', '<End>', { noremap = true, silent = true, desc = "Move to line end" })
vim.keymap.set('i', '<C-b>', '<C-o>b', { noremap = true, silent = true, desc = "Move word backward" })
vim.keymap.set('i', '<C-f>', '<C-o>w', { noremap = true, silent = true, desc = "Move word forward" })

-- Delete word in insert mode
vim.keymap.set('i', '<C-w>', '<C-o>db', { noremap = true, silent = true, desc = "Delete word backward" })

