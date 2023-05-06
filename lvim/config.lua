--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]

-- vim options
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.relativenumber = false
vim.opt.colorcolumn = "120"
vim.opt.timeoutlen = 300

-- general
lvim.log.level = "warn"
lvim.format_on_save = {
  enabled = true,
  pattern = "*.lua",
  timeout = 1000,
}

vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" 

require("user.keybindings")

-------------------------------------------------------------------------------------

lvim.colorscheme = "onedark"
--------------------------------------------------------------------------------

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.matchup.enable = true

-- cmp sources config
lvim.builtin.cmp.cmdline.enable = true
table.insert(lvim.builtin.cmp.sources, {
  name = 'nvim_lsp_signature_help'
});

-- copilot-cmp config here, an AI plugin
table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    vim.defer_fn(function()
      require("copilot").setup() -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
      require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
    end, 100)
  end,
})

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- always installed on startup, useful for parsers without a strict filetype
lvim.builtin.treesitter.ensure_installed = { 
  "comment",
  "markdown_inline",
  "regex",
  "rust",
  "go",
  "gomod",
  "python",
  "html",
  "json",
  "lua",
}

-- -- generic LSP settings <https://www.lunarvim.org/docs/configuration/language-features/language-servers>

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "rust_analyzer",
  "gopls",
})

-- -- Additional Plugins <https://www.lunarvim.org/docs/configuration/plugins/user-plugins>
require("user.plugins").config()

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })


---------------------------------------------------------------------------------
------------------------
-- Format config
------------------------
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  -- { command = "stylua", filetypes = { "lua" } },
  { 
    command = "goimports", 
    filetypes = { "go" } 
  },
  { 
    command = "gofumpt", 
    filetypes = { "go" } 
  },
  { 
    name = "black", 
    args = {"--line-length", "80"},
    filetypes = { "python" },
  },
}

-- lvim.format_on_save.enabled = true
-- lvim.format_on_save = {
--   pattern = { "*.go", "*.py" },
-- }

------------------------
-- Linter config
------------------------
local linters = require "lvim.lsp.null-ls.linters"
linters.setup { 
  { 
    command = "flake8", 
    args = {"--max-line-length", "120"},
    filetypes = { "python" } ,
  } 
}

------------------------
-- Dap
------------------------
local dap_ok, dapgo = pcall(require, "dap-go")
if not dap_ok then
  return
end

dapgo.setup()

---------------------------------------------------------------------------------
------------------------
-- LSP
------------------------
-- config skip lsp server
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "rust_analyzer",  -- rust
  "gopls",  -- go
})

-- go
local lsp_manager = require "lvim.lsp.manager"
lsp_manager.setup("golangci_lint_ls", {
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities(),
})

lsp_manager.setup("gopls", {
  on_attach = function(client, bufnr)
    require("lvim.lsp").common_on_attach(client, bufnr)
    local _, _ = pcall(vim.lsp.codelens.refresh)
    local map = function(mode, lhs, rhs, desc)
      if desc then
        desc = desc
      end

      vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
    end
    map("n", "<leader>Gi", "<cmd>GoInstallDeps<Cr>", "Install Go Dependencies")
    map("n", "<leader>Gt", "<cmd>GoMod tidy<cr>", "Tidy")
    map("n", "<leader>Ga", "<cmd>GoTestAdd<Cr>", "Add Test")
    map("n", "<leader>GA", "<cmd>GoTestsAll<Cr>", "Add All Tests")
    map("n", "<leader>Ge", "<cmd>GoTestsExp<Cr>", "Add Exported Tests")
    map("n", "<leader>Gg", "<cmd>GoGenerate<Cr>", "Go Generate")
    map("n", "<leader>Gf", "<cmd>GoGenerate %<Cr>", "Go Generate File")
    map("n", "<leader>Gc", "<cmd>GoCmt<Cr>", "Generate Comment")
    map("n", "<leader>GDT", "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test")
  end,
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities(),
  settings = {
    gopls = {
      usePlaceholders = true,
      gofumpt = true,
      codelenses = {
        generate = false,
        gc_details = true,
        test = true,
        tidy = true,
      },
    },
  },
})

local status_ok, gopher = pcall(require, "gopher")
if not status_ok then
  return
end

gopher.setup {
  commands = {
    go = "go",
    gomodifytags = "gomodifytags",
    gotests = "gotests",
    impl = "impl",
    iferr = "iferr",
  },
}

------------------

-- 



-- setup debug adapter
---------------------------------------------------------------------------------
lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")

-- for rust
local codelldb_adapter = {
  type = "server",
  port = "${port}",
  executable = {
    command = mason_path .. "bin/codelldb",
    args = { "--port", "${port}" },
    -- On windows you may have to uncomment this:
    -- detached = false,
  },
}

pcall(function()
  require("rust-tools").setup {
    tools = {
      executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
      reload_workspace_from_cargo_toml = true,
      runnables = {
        use_telescope = true,
      },
      inlay_hints = {
        auto = true,
        -- only_current_line = true,
        only_current_line = false,
        -- show_parameter_hints = false,
        show_parameter_hints = true,
        parameter_hints_prefix = "<-",
        other_hints_prefix = "=>",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
      },
    hover_actions = {
        border = "rounded",
      },
      on_initialized = function()
        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
          pattern = { "*.rs" },
          callback = function()
            local _, _ = pcall(vim.lsp.codelens.refresh)
          end,
        })
      end,
    },
    dap = {
      adapter = codelldb_adapter,
    },
    server = {
      on_attach = function(client, bufnr)
        require("lvim.lsp").common_on_attach(client, bufnr)
        local rt = require "rust-tools"
        vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
      end,

      capabilities = require("lvim.lsp").common_capabilities(),
      settings = {
        ["rust-analyzer"] = {
          lens = {
            enable = true,
          },
          checkOnSave = {
            enable = true,
            command = "clippy",
          },
        },
      },
    },
  }
end)

lvim.builtin.dap.on_config_done = function(dap)
  dap.adapters.codelldb = codelldb_adapter
  dap.configurations.rust = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }
end

vim.api.nvim_set_keymap("n", "<m-d>", "<cmd>RustOpenExternalDocs<Cr>", { noremap = true, silent = true })

-- Rust over
-- Python dap config
--
pcall(function()
  require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)
-- setup testing
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      -- Extra arguments for nvim-dap configuration
      -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
      dap = {
        justMyCode = false,
        console = "integratedTerminal",
      },
      args = { "--log-level", "DEBUG", "--quiet" },
      runner = "pytest",
    })
  }
})


-- Python over

lvim.builtin.which_key.mappings["R"] = {
  name = "Rust",
  r = { "<cmd>RustRunnables<Cr>", "Runnables" },
  t = { "<cmd>lua _CARGO_TEST()<cr>", "Cargo Test" },
  m = { "<cmd>RustExpandMacro<Cr>", "Expand Macro" },
  c = { "<cmd>RustOpenCargo<Cr>", "Open Cargo" },
  p = { "<cmd>RustParentModule<Cr>", "Parent Module" },
  d = { "<cmd>RustDebuggables<Cr>", "Debuggables" },
  v = { "<cmd>RustViewCrateGraph<Cr>", "View Crate Graph" },
  R = {
    "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<Cr>",
    "Reload Workspace",
  },
  o = { "<cmd>RustOpenExternalDocs<Cr>", "Open External Docs" },
  y = { "<cmd>lua require'crates'.open_repository()<cr>", "[crates] open repository" },
  P = { "<cmd>lua require'crates'.show_popup()<cr>", "[crates] show popup" },
  i = { "<cmd>lua require'crates'.show_crate_popup()<cr>", "[crates] show info" },
  f = { "<cmd>lua require'crates'.show_features_popup()<cr>", "[crates] show features" },
  D = { "<cmd>lua require'crates'.show_dependencies_popup()<cr>", "[crates] show dependencies" },
}
lvim.builtin.which_key.mappings["G"] = { name = "Go" }
-- lvim.builtin.which_key.mappings["D"] = { name = "Debug" }

------------------------------------------------------config rust ide over ------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  command = "set tabstop=2  shiftwidth=2"
})

-- NOTE: the following keybinds are wrapped in an filetype autocommand so they are only active in python files
-- you could also add the code in the callback function to lvim/ftplugin/python.lua
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "python" },
  callback = function()
    lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('neotest').run.run()<cr>",
      "Test Method" }
    lvim.builtin.which_key.mappings["dM"] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
      "Test Method DAP" }
    lvim.builtin.which_key.mappings["df"] = {
      "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test Class" }
    lvim.builtin.which_key.mappings["dF"] = {
      "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test Class DAP" }
    lvim.builtin.which_key.mappings["dS"] = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" }
    lvim.builtin.which_key.vmappings["d"] = {
      name = "Debug",
      s = { "<cmd>lua require('dap-python').debug_selection()<cr>", "Debug Selection" },
    }
    lvim.builtin.which_key.mappings["C"] = {
      name = "Python",
      c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
    }
  end,
})
