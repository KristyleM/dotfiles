local M = {}

M.config = function()
  -- local neoclip_req = { "kkharji/sqlite.lua" }
  -- if lvim.builtin.neoclip.enable_persistent_history == false then
  --   neoclip_req = {}
  -- end
  lvim.plugins = {
    -- themes
    {
      'navarasu/onedark.nvim',
        config = function()
        require("onedark").setup {
          style = "darker",
        }
      end
    },
    -- easy motion plugin
    {
      "phaazon/hop.nvim",
      event = "BufRead",
      config = function()
        require("hop").setup()
        -- vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
        -- vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
      end,
    },
    -- search and replace in project
    {
      "windwp/nvim-spectre",
      event = "BufRead",
      config = function()
        require("spectre").setup()
      end,
    },
    -- navigate and highlight matching words
    -- with lvim.builtin.treesitter.matchup.enable = true in option 
    -- {
    --   "andymass/vim-matchup",
    --   event = "CursorMoved",
    --   config = function()
    --     vim.g.matchup_matchparen_offscreen = { method = "popup" }
    --   end,
    -- },
    -- git wrapper, use git command in lvim
    {
      "tpope/vim-fugitive",
      cmd = {
        "G",
        "Git",
        "Gdiffsplit",
        "Gread",
        "Gwrite",
        "Ggrep",
        "GMove",
        "GDelete",
        "GBrowse",
        "GRemove",
        "GRename",
        "Glgrep",
        "Gedit"
      },
      ft = {"fugitive"}
    },
    -- commentstring option based on the cursor location
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "BufRead",
    },
    -- autoclose and autorename html tag
    {
      "windwp/nvim-ts-autotag",
      config = function()
        require("nvim-ts-autotag").setup()
      end,
    },
    -- rainbow parentheses
    {
      "mrjones2014/nvim-ts-rainbow",
    },
    -- Show current function at the top of the screen when function does not fit in screen
    {
    "romgrk/nvim-treesitter-context",
      config = function()
        require("treesitter-context").setup{
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          throttle = true, -- Throttles plugin updates (may improve performance)
          max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
          patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
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
    -- previewing goto definition calls
    {
      "rmagatti/goto-preview",
      config = function()
      require('goto-preview').setup {
            width = 120; -- Width of the floating window
            height = 25; -- Height of the floating window
            default_mappings = false; -- Bind default mappings
            debug = false; -- Print debug information
            opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
            post_open_hook = nil -- A function taking two arguments, a buffer and a window to be ran as a hook.
            -- You can use "default_mappings = true" setup option
            -- Or explicitly set keybindings
            -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
            -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
            -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
        }
      end
    },
    -- hint when you type
    {
      "ray-x/lsp_signature.nvim",
      event = "BufRead",
      config = function() require"lsp_signature".on_attach() end,
    },
    -- a tree like view for symbols
    {
      "simrat39/symbols-outline.nvim",
      config = function()
        require('symbols-outline').setup()
      end
    },
    -- ai plugin, github copilot
    {
      "zbirenbaum/copilot-cmp",
      event = "InsertEnter",
      dependencies = { "zbirenbaum/copilot.lua" },
      config = function()
        vim.defer_fn(function()
          require("copilot").setup() -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
          require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
        end, 100)
      end,
    },
    -- enable repeating supported plugin maps with "."
    { "tpope/vim-repeat" },
    -- mappings to delete, change and add surroundings
    {
      "tpope/vim-surround",

      -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
      -- setup = function()
        --  vim.o.timeoutlen = 500
      -- end
    },
    -- diagnostics, references, telescope results, quickfix and location lists
    {
      "folke/trouble.nvim",
        cmd = "TroubleToggle",
    },
  }
end

return M
