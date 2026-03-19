return {
	"WilliamHsieh/overlook.nvim",
	opts = {},
	keys = {
		{ "<leader>pd", function() require("overlook.api").peek_definition() end, desc = "Peek Definition" },
		{ "<leader>pp", function() require("overlook.api").peek_cursor() end, desc = "Peek Cursor" },
		{ "<leader>pu", function() require("overlook.api").restore_popup() end, desc = "Restore Last Popup" },
		{ "<leader>pU", function() require("overlook.api").restore_all_popups() end, desc = "Restore All Popups" },
		{ "<leader>pc", function() require("overlook.api").close_all() end, desc = "Close All Popups" },
		{ "<leader>pf", function() require("overlook.api").switch_focus() end, desc = "Switch Focus" },
		{ "<leader>ps", function() require("overlook.api").open_in_split() end, desc = "Open in Split" },
		{ "<leader>pv", function() require("overlook.api").open_in_vsplit() end, desc = "Open in Vsplit" },
		{ "<leader>pt", function() require("overlook.api").open_in_tab() end, desc = "Open in Tab" },
		{ "<leader>po", function() require("overlook.api").open_in_original_window() end, desc = "Open in Current Window" },
	},
}
