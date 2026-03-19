return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		spec = {
			-- Leader key groups
			{ "<leader>a", group = "Avante (AI)" },
			{ "<leader>f", group = "Find (fzf)" },
			{ "<leader>g", group = "Git" },
			{ "<leader>x", group = "Trouble" },
			{ "<leader>c", group = "Code" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>p", group = "Peek (Overlook)" },

			-- LSP keymaps
			{ "<leader>rn", desc = "Rename Symbol" },
			{ "<leader>ld", desc = "Line Diagnostics" },
			{ "<leader>lh", desc = "Toggle Inlay Hints" },
			{ "<leader>f", desc = "fzf search", mode = "n" },
			{ "gr", desc = "Go to References" },
			{ "gd", desc = "Go to Definition" },
			{ "K", desc = "Hover Documentation", mode = "n" },

			-- fzf-lua
			{ "<leader>ff", desc = "Find Files" },
			{ "<leader>fg", desc = "Find Git Files" },
			{ "<leader>fc", desc = "Live Grep" },
			{ "<leader>fr", desc = "Resume Search" },
			{ "<leader>fo", desc = "Recent Files" },

			-- Git
			{ "<leader>gp", desc = "Preview Hunk" },

			-- Trouble
			{ "<leader>xx", desc = "Diagnostics" },
			{ "<leader>xX", desc = "Buffer Diagnostics" },
			{ "<leader>xL", desc = "Location List" },
			{ "<leader>xQ", desc = "Quickfix List" },
			{ "<leader>cs", desc = "Symbols" },
			{ "<leader>cl", desc = "LSP Definitions/References" },

			-- Overlook (Peek)
			{ "<leader>pd", desc = "Peek Definition" },
			{ "<leader>pp", desc = "Peek Cursor" },
			{ "<leader>pu", desc = "Restore Last Popup" },
			{ "<leader>pU", desc = "Restore All Popups" },
			{ "<leader>pc", desc = "Close All Popups" },
			{ "<leader>pf", desc = "Switch Focus" },
			{ "<leader>ps", desc = "Open in Split" },
			{ "<leader>pv", desc = "Open in Vsplit" },
			{ "<leader>pt", desc = "Open in Tab" },
			{ "<leader>po", desc = "Open in Current Window" },

			-- Flash
			{ "\\s", desc = "Flash Jump", mode = { "n", "x", "o" } },

			-- Marks/Jump
			{ "`.", desc = "Jump to last change" },
			{ "`\"", desc = "Jump to last exit position" },
			{ "`^", desc = "Jump to last insert end" },
			{ "`[", desc = "Jump to change/paste start" },
			{ "`]", desc = "Jump to change/paste end" },
			{ "`<", desc = "Jump to selection start" },
			{ "`>", desc = "Jump to selection end" },
			{ "``", desc = "Jump to last edited file" },

			-- Avante (AI)
			{ "<leader>aa", desc = "Ask AI" },
			{ "<leader>ae", desc = "Edit with AI", mode = { "n", "v" } },
			{ "<leader>ar", desc = "Refresh AI Response" },
			{ "<leader>af", desc = "Focus Avante" },
			{ "<leader>at", desc = "Toggle Avante" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps",
		},
	},
}
