return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-mini/mini.icons" },
	config = function()
		require("fzf-lua").setup({
			files = {
				fd_opts = [[--type f --hidden --follow --exclude .git --exclude node_modules --exclude target --exclude __pycache__]],
			},
			grep = {
				rg_opts = [[--hidden --follow --glob "!.git" --glob "!node_modules" --glob "!target" -g "!__pycache__" --column --line-number --no-heading --color=always --smart-case]],
			},
			oldfiles = {
				cwd_only = true, -- 只显示当前项目的最近文件
			},
		})
		vim.keymap.set("n", "<leader>ff", require("fzf-lua").files, { desc = "Search over files" })
		vim.keymap.set("n", "<leader>fg", require("fzf-lua").git_files, { desc = "Search over git files" })
		vim.keymap.set("n", "<leader>fc", require("fzf-lua").live_grep, { desc = "Live grep" })
		vim.keymap.set("n", "<leader>fr", require("fzf-lua").resume, { desc = "Resume fzf-lua" })
		vim.keymap.set("n", "<leader>fo", require("fzf-lua").oldfiles, { desc = "Recent files" })
	end,
}
