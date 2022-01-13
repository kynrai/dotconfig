vim.opt.cursorline = true					-- highlight the line
vim.opt.number = true						-- show line numbers
vim.opt.relativenumber = true					-- show line numbers relative to cursor
vim.opt.backup = false						-- no backup files
vim.opt.swapfile = false					-- no swap files
vim.opt.signcolumn = 'yes'					-- always show the sign column / git gutter
vim.opt.title = true						-- set the terminal title
vim.opt.showmatch = true					-- show matching parenthesis
vim.opt.undolevels = 10000					-- set the number of undos available
vim.opt.copyindent = true					-- copy the previous indetation on autoindenting
vim.opt.wildmode = 'list:full'					-- show full list of options on wild menu tab complete
vim.opt.showmode = false					-- hide mode, for use with status line plugins
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }	-- better completion experiance
vim.opt.termguicolors = true					-- true color mode
vim.opt.splitright = true					-- v split to right 
vim.opt.splitbelow = true					-- h split to bottom
vim.opt_global.mouse :append('a')				-- enable mouse support
vim.opt_global.shortmess:remove("F"):append("c")		-- useful for scala
