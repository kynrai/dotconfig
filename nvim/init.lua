-- Navigation help
-- Search for the key to jump to a section
--
-- 1. Options	(NavOptions)
-- 2. Plugins	(NavPlugins)
-- 3. LSP	(NavLSP)
-- 4. Theme	(NavTheme)
-- 5. Mappings	(NavMappings)
-- 6. Golang	(NavGolang)

-- options (NavOptions)
-- Set custom options for nvim in lua
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

-- packer (NavPlugins)
-- bootstrap packer to install if it does not already exist
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'shaunsingh/nord.nvim'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use {'nvim-lualine/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}}
  use {'kyazdani42/nvim-tree.lua', requires = {'kyazdani42/nvim-web-devicons', opt = true}}
  use 'neovim/nvim-lspconfig'
  use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/plenary.nvim'}}
  use 'tversteeg/registers.nvim'
  use 'b3nj5m1n/kommentary'
  use {
    'crispgm/nvim-tabline',
    config = function() require('tabline').setup({}) end,
  }
  use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}

  -- languages support
  use 'ray-x/go.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)

require'nvim-tree'.setup {
  open_on_setup = true,
  open_on_tab = true,
  auto_close = true,
}

require'lualine'.setup {options = {theme = 'nord'}}

require'nvim-web-devicons'.setup {default = true}

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {enable = true},
  indent = {enable = true}
}

-- setup telescope
require'telescope'.setup {defaults = {
  layout_config = {horizontal = {preview_width = 0.65}},
}}

require'kommentary.config'.configure_language("default", {prefer_single_line_comments = true})

require'gitsigns'.setup {
  current_line_blame = true,
  current_line_blame_formatter_opts = {relative_time = true},
}

-- LSP settings (NavLSP)
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'rust_analyzer', 'tsserver', 'gopls', 'terraformls' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end

-- set some rules for some of the lsp
vim.api.nvim_exec([[ autocmd BufWritePre *.tf lua vim.lsp.buf.formatting_sync() ]], false)

-- set colourscheme (NavTheme)
vim.g.nord_contrast = true
vim.g.nord_borders = true
require('nord').set()

-- mappings (NavMappings)
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
map('n', '<leader>gw', ':tabclose<CR>', {noremap = true})		-- quick way to close a tab
map('n', '<leader>ff', ':Telescope find_files<CR>', {noremap = true}) 	-- find all files with telescope
map('n', '<leader>fg', ':Telescope live_grep<CR>', {noremap = true}) 	-- find things files with telescope
map('n', '<leader>fb', ':Telescope buffers<CR>', {noremap = true}) 	-- find all buffers with telescope
map('n', '<leader>fh', ':Telescope help_tags<CR>', {noremap = true}) 	-- find help files with telescope
map('n', '<leader>b', ':NvimTreeToggle<CR>', {noremap = true}) 		-- for opening and closer the file browser
map('n', '<leader>h', ':Gitsigns preview_hunk<CR>', {noremap = true}) 	-- show the git hunk

-- golang (NavGolang)
require('go').setup()
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)

