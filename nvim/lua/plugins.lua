local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn

-- ensure that packer is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
	execute 'packadd packer.nvim'
end

vim.cmd('packadd packer.nvim')

local packer = require'packer'
local util = require'packer.util'

packer.init({
	package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

--- startup and add configure plugins
packer.startup(function()
	local use = use
	use 'wbthomason/packer.nvim'
	use 'marko-cerovac/material.nvim'
	use {
		'hoob3rt/lualine.nvim',
		requires = {'kyazdani42/nvim-web-devicons', opt = true}
	}
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}
	use 'neovim/nvim-lspconfig'
	use 'nvim-lua/completion-nvim'
	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use 'phaazon/hop.nvim'
	use {
		'lewis6991/gitsigns.nvim',
		requires = {'nvim-lua/plenary.nvim'}
	}
	use {
		'kyazdani42/nvim-tree.lua',
		requires = 'kyazdani42/nvim-web-devicons'
	}
	use 'norcalli/snippets.nvim'
	use 'glepnir/lspsaga.nvim'
	use 'b3nj5m1n/kommentary'
	use 'ray-x/go.nvim'
end
)


-- setup lualine and fonts
require'lualine'.setup{
	options = {theme = 'material-nvim'},
}

require'nvim-web-devicons'.setup {
	default = true;
}

require'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained",
	highlight = {
		enable = true,
	},
}

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap=true, silent=true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
	buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'rust_analyzer', 'tsserver', 'gopls' }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup {
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		}
	}
end

vim.g.completion_enable_snippet = 'snippets.nvim'

-- TODO https://github.com/nvim-lua/completion-nvim Add more snippets and completion sources
-- Setup completion on all buffers
vim.cmd('autocmd BufEnter * lua require\'completion\'.on_attach()')

-- Setup telescope
require('telescope').setup({
	defaults = {
		layout_config = {
			horizontal = {
				preview_width = 0.65,
			},
		},
	},
})

require('gitsigns').setup({
	current_line_blame = true,
	current_line_blame_formatter_opts = {
		relative_time = true
	},
})

require'snippets'.snippets = {}

require('lspsaga').init_lsp_saga()
