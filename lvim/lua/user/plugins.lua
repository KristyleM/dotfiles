local M = {}

M.config = function()
  -- local neoclip_req = { "kkharji/sqlite.lua" }
  -- if lvim.builtin.neoclip.enable_persistent_history == false then
  --   neoclip_req = {}
  -- end
  lvim.plugins = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      after = "nvim-treesitter",
      dependencies = "nvim-treesitter/nvim-treesitter",
    },
    {
      "folke/trouble.nvim",
      cmd = "TroubleToggle",
    },
    require("user.plugins.visual-multi"),
    {
      "rmagatti/goto-preview",
      config = function()
        require('goto-preview').setup {
          width = 120,             -- Width of the floating window
          height = 25,             -- Height of the floating window
          default_mappings = true, -- Bind default mappings
          debug = false,           -- Print debug information
          opacity = nil,           -- 0-100 opacity level of the floating window where 100 is fully transparent.
          post_open_hook = nil     -- A function taking two arguments, a buffer and a window to be ran as a hook.
          -- You can use "default_mappings = true" setup option
          -- Or explicitly set keybindings
          -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
          -- vim.cmd("nnoremap gpt <cmd>lua require('goto-preview').goto_preview_type_definition()<CR>")
          -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
          -- vim.cmd("nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>")
          -- vim.cmd("nnoremap gpc <cmd>lua require('goto-preview').close_all_win()<CR>")
        }
      end
    },
    require("user.plugins.lspsaga"),
    {
      "ray-x/lsp_signature.nvim",
      config = function()
        require("user.plugins.lsp_signature").config()
      end,
      event = { "BufRead", "BufNew" },
    },
    {
      "sindrets/diffview.nvim",
      lazy = true,
      cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
      keys = { "<leader>gd", "<leader>gh" },
      config = function()
        require("user.plugins.diffview").config()
      end,
    },
    {
      "simrat39/symbols-outline.nvim",
      config = function()
        require("user.plugins.symbols_outline").config()
      end,
      event = "BufReadPost",
    },
    {
      "phaazon/hop.nvim",
      event = "VeryLazy",
      config = function()
        require("user.plugins.hop").config()
      end,
    },
    {
      "kylechui/nvim-surround",
      event = "VeryLazy",
      config = true,
      dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects", -- recommended
      },
    },
    {
      "roobert/surround-ui.nvim",
      event = "VeryLazy",
      dependencies = {
        "folke/which-key.nvim",
        "kylechui/nvim-surround",
      },
    },
    {
      -- numb.nvim is a Neovim plugin that peeks lines of the buffer in non-obtrusive way.
      "nacro90/numb.nvim",
      event = "BufRead",
      config = function()
        require("numb").setup {
          show_numbers = true,    -- Enable 'number' for the window while peeking
          show_cursorline = true, -- Enable 'cursorline' for the window while peeking
        }
      end,
    },
    {
      "kevinhwang91/nvim-bqf",
      event = { "BufRead", "BufNew" },
      config = function()
        require("bqf").setup({
          auto_enable = true,
          preview = {
            win_height = 12,
            win_vheight = 12,
            delay_syntax = 80,
            border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
          },
          func_map = {
            vsplit = "",
            ptogglemode = "z,",
            stoggleup = "",
          },
          filter = {
            fzf = {
              action_for = { ["ctrl-s"] = "split" },
              extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
            },
          },
        })
      end,
    },
    {
      "WhoIsSethDaniel/mason-tool-installer",
      config = function()
        require("user.plugins.mason_tool_installer").config()
      end
    },
    {
      "s1n7ax/nvim-window-picker",
      version = "1.*",
      config = function()
        require("window-picker").setup({
          autoselect_one = true,
          include_current = false,
          filter_rules = {
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },

              -- if the buffer type is one of following, the window will be ignored
              buftype = { "terminal" },
            },
          },
          other_win_hl_color = "#e35e4f",
        })
      end,
    },
    { "mrjones2014/nvim-ts-rainbow" },
    {
      "andymass/vim-matchup",
      event = "CursorMoved",
      config = function()
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
      end,
    },
    { "simrat39/rust-tools.nvim" },
    {
      "saecki/crates.nvim",
      version = "v0.3.0",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("crates").setup {
          null_ls = {
            enabled = true,
            name = "crates.nvim",
          },
          popup = {
            border = "rounded",
          },
        }
      end,
    },
    {
      "windwp/nvim-ts-autotag",
      config = function()
        require("nvim-ts-autotag").setup()
      end,
    },
    {
      "romgrk/nvim-treesitter-context",
      config = function()
        require("treesitter-context").setup {
          enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
          throttle = true, -- Throttles plugin updates (may improve performance)
          max_lines = 0,   -- How many lines the window should span. Values <= 0 mean no limit.
          patterns = {
            -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the 'default' entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
              'class',
              'function',
              'method',
            },
          },
        }
      end
    },
    {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup({ "css", "scss", "html", "javascript", "lua", "typescript" }, {
          RGB = true,      -- #RGB hex codes
          RRGGBB = true,   -- #RRGGBB hex codes
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          rgb_fn = true,   -- CSS rgb() and rgba() functions
          hsl_fn = true,   -- CSS hsl() and hsla() functions
          css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
        }
        )
      end,
    },
    {
      "folke/todo-comments.nvim",
      event = "BufRead",
      config = function()
        require("todo-comments").setup()
      end,
    },
    {
      "zbirenbaum/copilot-cmp",
      event = "InsertEnter",
      dependencies = { "zbirenbaum/copilot.lua" },
      config = function()
        vim.defer_fn(function()
          require("copilot").setup()     -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
          require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
        end, 100)
      end,
    },
    { "tpope/vim-repeat" },
    { "NLKNguyen/papercolor-theme" }, -- theme
    {
      "windwp/nvim-spectre",
      event = "BufRead",
      config = function()
        require("spectre").setup()
      end,
    },
    { 'marko-cerovac/material.nvim' }, -- theme
    {
      'navarasu/onedark.nvim',         -- theme
      config = function()
        require("onedark").setup {
          style = "darker",
        }
      end
    },
    {
      -- Standalone UI for nvim-lsp progress
      'j-hui/fidget.nvim',
      config = function()
        require "fidget".setup {}
      end
    },
    -- { "hrsh7th/cmp-nvim-lsp-signature-help" },
    -- -----------------------------------------------------------
    -- Go language config following
    { "olexsmir/gopher.nvim" },
    { "leoluz/nvim-dap-go" },
    -- -----------------------------------------------------------
    -- -----------------------------------------------------------
    -- Python language config following
    { "ChristianChiarulli/swenv.nvim" },
    { "stevearc/dressing.nvim" },
    { "mfussenegger/nvim-dap-python" },
    { "nvim-neotest/neotest" },
    { "nvim-neotest/neotest-python" },
    -- -----------------------------------------------------------
    { "kshenoy/vim-signature" },
    {
      "aserowy/tmux.nvim",
      config = function()
        require("user.plugins.tmux").config()
      end
    },
  }
end

return M
