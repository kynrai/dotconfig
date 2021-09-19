vim.api.nvim_exec([[ autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)]], false)
-- vim.cmd('autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)')
