---
--- LSP Zero setup (can hopefully be replaced when native autocomplete is released in 0.11)
---
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Auto-install lazy.nvim if not present
if not vim.uv.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  print('Done.')
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {'catppuccin/nvim', name = "catppuccin", priority = 1000},
  {'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'},
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},
  {'neovim/nvim-lspconfig'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/nvim-cmp'},
})

vim.opt.termguicolors = true
vim.cmd.colorscheme('catppuccin-frappe')

local lsp_zero = require('lsp-zero')

-- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
local lsp_attach = function(client, bufnr)
  local opts = {buffer = bufnr}

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  mapping = cmp.mapping.preset.insert({}),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
})

---
--- Forked config from https://gitlab.com/linuxdabbler/dotfiles/-/blob/main/.config/nvim/init.lua
---

-- vim.g.mapleader = " " -- sets leader key to space

-- Functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- My own settings
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.path:append('**') -- enable "fuzzy find" in command mode
vim.opt.wildignore = '*/node_modules/*' -- ignore in "fuzzy find"
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.tabstop = 2 -- use two spaces
vim.opt.shiftwidth = 2 -- use two spaces for auto-ident
vim.opt.splitright = true -- split windows to the right
vim.opt.guicursor = 'a:blinkon100' -- enable blinking cursor

function Split() -- function for splitting into four windows
  vim.cmd('vnew')
  vim.cmd('bo term')
  vim.cmd('vert term')
  vim.cmd('resize 20')
end

-- Get clipboard to work in Crostini
vim.cmd('source ~/.config/nvim/osc52.vim')
vim.keymap.set("v", '"+y', function()
  vim.cmd('normal! y')  -- Yank the visual selection
  local yanked_text = vim.fn.getreg('"')
  vim.fn.SendViaOSC52(yanked_text)
end, { noremap = true, silent = true })
