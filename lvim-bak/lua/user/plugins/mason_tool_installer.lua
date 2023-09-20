local M = {}

M.config = function()
	local status_ok, mti = pcall(require, "mason-tool-installer")
	if not status_ok then
		return
	end

	local cfg = {
		ensure_installed = {
			-- you can pin a tool to a particular version
			-- { 'golangci-lint', version = 'v1.47.0' },
			-- you can turn off/on auto_update per tool
			{ "bash-language-server", auto_update = true },
			"lua-language-server",
			"vim-language-server",
			"impl",
			"tailwindcss-language-server",
			"taplo",
			"marksman",
			-- lua
			"stylua",
			"lua-language-server",
			-- json
			"json-to-struct",
			"json-lsp",
			-- python
			"pyright",
			"black",
			"flake8",
			-- go
			"gopls",
			"gotests",
			"gofumpt",
			"goimports",
			"goimports",
			"gomodifytags",
			"golangci-lint-langserver",
			-- rust
			"rust-analyzer",
			"rustfmt",
			-- html
			"html-lsp",
			"css-lsp",
			-- sql
			"sqlls",
			"graphql-language-service-cli",
			-- typescript
			"typescript-language-server",
			-- yaml
			"yaml-language-server",
			"yamlfmt",
			-- debug
			"codelldb",
			"delve",
			"delve",
		},

		-- if set to true this will check each tool for updates. If updates
		-- are available the tool will be updated. This setting does not
		-- affect :MasonToolsUpdate or :MasonToolsInstall.
		-- Default: false
		auto_update = false,

		-- automatically install / update on startup. If set to false nothing
		-- will happen on startup. You can use :MasonToolsInstall or
		-- :MasonToolsUpdate to install tools and check for updates.
		-- Default: true
		run_on_start = true,

		-- set a delay (in ms) before the installation starts. This is only
		-- effective if run_on_start is set to true.
		-- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
		-- Default: 0
		start_delay = 3000, -- 3 second delay

		-- Only attempt to install if 'debounce_hours' number of hours has
		-- elapsed since the last time Neovim was started. This stores a
		-- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
		-- This is only relevant when you are using 'run_on_start'. It has no
		-- effect when running manually via ':MasonToolsInstall' etc....
		-- Default: nil
		debounce_hours = 5, -- at least 5 hours between attempts to install/update
	}

	mti.setup(cfg)
end

return M
