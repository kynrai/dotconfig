-- Navigation help
-- Search for the key to jump to a section
--
-- 1. Options	(NavOptions)
-- 2. Plugins	(NavPlugins)
-- 3. LSP		(NavLSP)
-- 4. Theme		(NavTheme)
-- 5. Mappings	(NavMappings)

-- options (NavOptions)
-- Set custom options for nvim in lua
vim.opt.backup = false                                      -- no backup files
vim.opt.completeopt = { "menuone", "noinsert", "noselect" } -- better completion experiance
vim.opt.copyindent = true                                   -- copy the previous indetation on autoindenting
vim.opt.cursorline = true                                   -- highlight the line
vim.opt.number = true                                       -- show line numbers
vim.opt.relativenumber = true                               -- show line numbers relative to cursor
vim.opt.shiftwidth = 4                                      -- shift 4 spaces when tab
vim.opt.showmatch = true                                    -- show matching parenthesis
vim.opt.showmode = false                                    -- hide mode, for use with status line plugins
vim.opt.signcolumn = 'yes'                                  -- always show the sign column / git gutter
vim.opt.splitbelow = true                                   -- h split to bottom
vim.opt.splitright = true                                   -- v split to right 
vim.opt.swapfile = false                                    -- no swap files
vim.opt.tabstop = 4                                         -- 1 tab == 4 spaces
vim.opt.termguicolors = true                                -- true color mode
vim.opt.title = true                                        -- set the terminal title
vim.opt.undolevels = 10000                                  -- set the number of undos available
vim.opt.wildmode = 'list:full'                              -- show full list of options on wild menu tab complete
vim.opt_global.mouse :append('a')                           -- enable mouse support

-- Better Netrw
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30
vim.g.netrw_keepdir = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_localcopydircmd = 'cp -r'
vim.g.netrw_list_hide = (vim.fn["netrw_gitignore#Hide"]()) .. [[,\(^\|\s\s\)\zs\.\S\+]] -- use .gitignore
vim.cmd[[highlight link netrwMarkFile Search]]

-- packer (NavPlugins)
-- bootstrap packer to install if it does not already exist
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use {'nvim-lualine/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}}
  use({ "jose-elias-alvarez/null-ls.nvim",
	  config = function()
        require("null-ls").setup()
      end,
      requires = { "nvim-lua/plenary.nvim" },
     })
  use 'folke/lsp-colors.nvim'
  use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/plenary.nvim'}}
  use 'tversteeg/registers.nvim'
  use 'terrortylor/nvim-comment'
  use 'joosepalviste/nvim-ts-context-commentstring'	
  use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
  use 'mofiqul/dracula.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)

require'lualine'.setup {options = {theme = 'dracula-nvim'}}

require'nvim-web-devicons'.setup {default = true}

require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = { "phpdoc" },
  highlight = {enable = true},
  indent = {enable = true},
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  }
}

-- setup telescope
require'telescope'.setup {defaults = {
  layout_config = {horizontal = {preview_width = 0.65}},
}}

require'gitsigns'.setup {
  current_line_blame = true,
  current_line_blame_formatter_opts = {relative_time = true},
}

require("nvim_comment").setup({
  comment_empty = false,
  hook = function()
    require("ts_context_commentstring.internal").update_commentstring()
  end,
})

local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local sources = { 
	null_ls.builtins.formatting.goimports,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = sources,
    -- you can reuse a shared lspconfig on_attach callback here
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({
                    bufnr = bufnr,
                    filter = function(client)
                      return client.name == "null-ls"
                   end
                  })
                end,
            })
        end
    end,
})

-- LSP settings (NavLSP)
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
}

require('lspconfig')['gopls'].setup{
    on_attach = on_attach,
    settings = {
    	experimentalWorkspaceModule = true
    }
}

require('lspconfig')['terraformls'].setup{
    on_attach = on_attach,
}

-- set some rules for some of the lsp
vim.api.nvim_exec([[ autocmd BufWritePre *.tf lua vim.lsp.buf.formatting_sync() ]], false)

-- set colourscheme (NavTheme)
vim.cmd[[colorscheme dracula]]
vim.cmd[[highlight link GitSignsCurrentLineBlame Visual]]

-- mappings (NavMappings)
vim.g.mapleader = ','							-- change the <leader> key to be comma

vim.keymap.set('n', '<CR>', ':noh<CR><CR>', {noremap = true})						-- clears search highlight & still be enter
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', {noremap = true})	-- find all files with telescope
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', {noremap = true})		-- find things files with telescope
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', {noremap = true})		-- find all buffers with telescope
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>', {noremap = true})		-- find help files with telescope
vim.keymap.set('n', '<leader>h', ':Gitsigns preview_hunk<CR>', {noremap = true})	-- show the git hunk
vim.keymap.set('n', '<leader>dd', ':Lexplore %:p:h<CR>', {noremap = true})			-- explore file
vim.keymap.set('n', '<Leader>da', ':Lexplore<CR>', {noremap = true})				-- explore directory
