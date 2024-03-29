-- LSP
-- https://github.com/glepnir/lspsaga.nvim

return {
  'glepnir/lspsaga.nvim',
  event = "BufRead",
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = {
    request_timeout = 5000,
    scroll_preview = {
      scroll_down = "<C-n>",
      scroll_up = "<C-p>",
    },
    ui = {
      border = "rounded",
      winblend = 0,
      colors = {
        normal_bg = "none",
        title_bg = "none",
      },
      expand = lvim.icons.ui.ChevronShortRight,
      collapse = lvim.icons.ui.ChevronShortDown,
      kind = {
        ['Array'] = { lvim.icons.kind.Array .. ' ', 'Type' },
        ['Function'] = { lvim.icons.kind.Function .. ' ', 'Function' },
        ['Interface'] = { lvim.icons.kind.Interface .. ' ', 'Interface' },
        ['Object'] = { lvim.icons.kind.Object .. ' ', 'Type' },
      },
    },
    outline = {
      keys = {
        jump = "<cr>"
      }
    },
    finder = {
      keys = {
        vsplit = "v",
        split = "s",
        quit = { "q", "<esc>" },
        edit = { "<cr>" },
        close_in_preview = "q",
      }
    },
    definition = {
      edit = "<cr>",
      vsplit = "<C-v>",
      split = "<C-s>",
      tabe = "<C-t>",
    },
    lightbulb = {
      enable_in_insert = false,
    },
    -- breadcrumbs
    -- https://github.com/glepnir/lspsaga.nvim#lspsaga-symbols-in-winbar
    symbol_in_winbar = {
      enable = false,
      separator = " " .. lvim.icons.ui.ChevronShortRight .. " ",
      color_mode = false,
    },
    beacon = {
      enable = false,
    },
  }
}

