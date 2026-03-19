return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup()

		vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
		-- Jump to previous/next git hunk
		vim.keymap.set("n", "[c", ":Gitsigns prev_hunk<CR>", { silent = true, desc = "Previous git hunk" })
		vim.keymap.set("n", "]c", ":Gitsigns next_hunk<CR>", { silent = true, desc = "Next git hunk" })
	end,
}
