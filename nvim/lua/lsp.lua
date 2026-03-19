-- Remove Global Default Key mapping
vim.keymap.del("n", "grn")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gO")

-- Create keymapping
-- LspAttach: After an LSP Client performs "initialize" and attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function (args)
        local keymap = vim.keymap
        local lsp = vim.lsp
	    local bufopts = { noremap = true, silent = true }

        keymap.set("n", "gr", lsp.buf.references, bufopts)
        keymap.set("n", "gd", lsp.buf.definition, bufopts)
        keymap.set("n", "<space>rn", lsp.buf.rename, bufopts)
        keymap.set("n", "K", lsp.buf.hover, bufopts)
        keymap.set("n", "<space>ld", vim.diagnostic.open_float, { noremap = true, silent = true, buffer = args.buf, desc = "Line diagnostics" })

        -- 启用 inlay hints
        local client = lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/inlayHint") then
            lsp.inlay_hint.enable(true, { bufnr = args.buf })
            keymap.set("n", "<space>lh", function()
                lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
            end, bufopts)
        end
    end
})

vim.lsp.enable({ "ty", "pyright", "gopls", "rust_analyzer", "html", "ts_ls", "cssls" })
