-- need a map method to handle the different kinds of key maps
local function map(mode, combo, mapping, opts)
	local options = {noremap = true}
	if opts then
		options = vim.tbl_extend('force', options, opts)
	end
	vim.api.nvim_set_keymap(mode, combo, mapping, options)
end

vim.g.mapleader = ','							-- change the <leader> key to be comma

map('n', '<CR>', ':noh<CR><CR>', {noremap = true})			-- clears search highlight & still be enter
map('n', '<leader>ff', ':Telescope find_files<CR>', {noremap = true}) 	-- find all files with telescope
map('n', '<leader>fg', ':Telescope live_grep<CR>', {noremap = true}) 	-- find things files with telescope
map('n', '<leader>fb', ':Telescope buffers<CR>', {noremap = true}) 	-- find all buffers with telescope
map('n', '<leader>fh', ':Telescope help_tags<CR>', {noremap = true}) 	-- find help files with telescope
map('n', '<leader>w', ':HopWord<CR>', {noremap = true}) 		-- for fast word nav
map('n', '<leader>b', ':NvimTreeToggle<CR>', {noremap = true}) 		-- for opening and closer the file browser
map('n', '<leader>h', ':Gitsigns preview_hunk<CR>', {noremap = true}) 	-- show the git hunk
map('n', 'gh', ':Lspsaga lsp_finder<CR>', {noremap = true}) 		-- show definitons in saga
map('n', '<leader>ca', ':Lspsaga code_action<CR>', {noremap = true}) 	-- show actions in saga

