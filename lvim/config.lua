--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]

lvim.colorscheme = "onedark"
require("user.options")
require("user.keybindings")

--------------------------------------------------------------------------------

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.matchup.enable = true
lvim.builtin.dap.active = true
lvim.format_on_save.enabled = false

-- cmp sources config
lvim.builtin.cmp.cmdline.enable = true
table.insert(lvim.builtin.cmp.sources, {
	name = "nvim_lsp_signature_help",
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
  "toml",
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

------------------------
-- Format config
------------------------
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ 
    command = "stylua", 
    filetypes = { "lua" } 
  },
	{
		command = "goimports",
		filetypes = { "go" },
	},
	{
		command = "gofumpt",
		filetypes = { "go" },
	},
	{
		name = "black",
		args = { "--line-length", "80" },
		filetypes = { "python" },
	},
})

------------------------
-- Linter config
------------------------
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{
		command = "flake8",
		args = { "--max-line-length", "120" },
		filetypes = { "python" },
	},
})

------------------------
-- LSP
------------------------
-- config skip lsp server
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
	"rust_analyzer", -- rust
	"gopls", -- go
})

-- language config
require("language.go") -- for go
require("language.rust") -- for rust

---------------------------------------------------------------------------------

-- Python dap config

local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
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
		}),
	},
})

-- Python over

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	command = "set tabstop=2  shiftwidth=2",
})

-- NOTE: the following keybinds are wrapped in an filetype autocommand so they are only active in python files
-- you could also add the code in the callback function to lvim/ftplugin/python.lua
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "python" },
	callback = function()
		lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('neotest').run.run()<cr>", "Test Method" }
		lvim.builtin.which_key.mappings["dM"] =
			{ "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Test Method DAP" }
		lvim.builtin.which_key.mappings["df"] = {
			"<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>",
			"Test Class",
		}
		lvim.builtin.which_key.mappings["dF"] = {
			"<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
			"Test Class DAP",
		}
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
