return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<space>lf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "n",
      desc = "Format document",
    },
  },
  opts = {
    formatters_by_ft = {
      rust = { "rustfmt" },
      python = { "black", "isort" },
      go = { "gofmt" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      json = { "prettier" },
      lua = { "stylua" },
    },
    default_format_opts = {
      timeout_ms = 3000,
      lsp_fallback = true,
    },
  },
}
