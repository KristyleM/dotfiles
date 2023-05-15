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
      { 'bash-language-server', auto_update = true },
      'lua-language-server',
      'vim-language-server',
      'impl',
      'tailwindcss-language-server',
      'taplo',
      'marksman',
      -- lua
      'stylua',
      'lua-language-server',
      -- json
      'json-to-struct',
      'json-lsp',
      -- python
      'pyright',
      'black',
      'flake8',
      -- go
      'gopls',
      'gotests',
      'gofumpt',
      'goimports',
      'goimports',
      'gomodifytags',
      'golangci-lint-langserver',
      -- rust
      'rust_analyzer',
      'rustfmt',
      -- html
      'html-lsp',
      'css-lsp',
      -- sql
      'sqlls',
      'graphql-language-service-cli',
      -- typescript
      'typescript-language-server',
      -- yaml
      'yaml-language-server',
      'yamlfmt',
      -- debug
      'codelldb',
      'delve',
      'delve',
    },
  }
  mti.setup(cfg)
end

return M

