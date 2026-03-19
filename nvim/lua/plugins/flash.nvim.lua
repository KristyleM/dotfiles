return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		modes = {
			char = {
				multi_line = false, -- 禁用 f/t 跨行跳转
				jump_labels = true, -- 显示跳转标签
			},
		},
	},
	keys = {
		{ "\\s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
	},
}
