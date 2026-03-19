return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Header (ASCII Art)
		dashboard.section.header.val = {
			[[                                                                        ]],
			[[ ██╗  ██╗██████╗ ██╗███████╗████████╗██╗   ██╗██╗     ███████╗███╗   ███╗]],
			[[ ██║ ██╔╝██╔══██╗██║██╔════╝╚══██╔══╝╚██╗ ██╔╝██║     ██╔════╝████╗ ████║]],
			[[ █████╔╝ ██████╔╝██║███████╗   ██║    ╚████╔╝ ██║     █████╗  ██╔████╔██║]],
			[[ ██╔═██╗ ██╔══██╗██║╚════██║   ██║     ╚██╔╝  ██║     ██╔══╝  ██║╚██╔╝██║]],
			[[ ██║  ██╗██║  ██║██║███████║   ██║      ██║   ███████╗███████╗██║ ╚═╝ ██║]],
			[[ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚══════╝╚═╝     ╚═╝]],
			[[                                                                        ]],
		}

		-- Menu
		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find File", "<cmd>FzfLua files<cr>"),
			dashboard.button("n", "  New File", "<cmd>ene<cr>"),
			dashboard.button("r", "  Recent Files", "<cmd>FzfLua oldfiles<cr>"),
			dashboard.button("g", "  Find Text", "<cmd>FzfLua live_grep<cr>"),
			dashboard.button("c", "  Configuration", "<cmd>e ~/.config/nvim/init.lua<cr>"),
			dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<cr>"),
			dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
		}

		-- Footer
		dashboard.section.footer.val = function()
			local stats = require("lazy").stats()
			local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			return "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
		end

		-- Colors
		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.section.footer.opts.hl = "AlphaFooter"

		-- Highlight groups
		vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#6272a4" })
		vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#f8f8f2" })
		vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#6272a4" })

		-- Layout
		dashboard.config.layout = {
			{ type = "padding", val = 4 },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			{ type = "padding", val = 2 },
			dashboard.section.footer,
		}

		alpha.setup(dashboard.config)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
