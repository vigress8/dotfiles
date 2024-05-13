vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local function setopts(opts)
  for k, v in pairs(opts) do
    vim.opt[k] = v
  end
end

-- https://github.com/lucasvianav/nvim/blob/62ac5c2aa8abb25094d7d896c3b58a0936c13984/lua/functions/utilities.lua#L39-L48
local function trim_trailing_whitespace()
  if not vim.o.binary and vim.o.filetype ~= 'diff' then
    local current_view = vim.fn.winsaveview()
    vim.cmd [[keeppatterns %s/\s\+$//e]]
    vim.fn.winrestview(current_view)
  end
end

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.pacscript',
  callback = function()
    setopts {
      filetype = 'sh',
      tabstop = 2,
      shiftwidth = 2,
    }
  end,
})

autocmd('BufWritePre', {
  pattern = '',
  callback = trim_trailing_whitespace,
})

autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

setopts {
  autoindent = true,
  breakindent = true,
  clipboard = 'unnamedplus',
  cursorline = false,
  expandtab = true,
  hlsearch = true,
  ignorecase = true,
  inccommand = 'split',
  listchars = { tab = '» ', trail = '·', nbsp = '␣' },
  list = true,
  mouse = 'a',
  number = true,
  relativenumber = true,
  scrolloff = 10,
  shiftwidth = 4,
  showmode = false,
  signcolumn = 'yes',
  smartcase = true,
  smarttab = true,
  softtabstop = 4,
  splitbelow = true,
  splitright = true,
  tabstop = 4,
  timeoutlen = 300,
  undofile = true,
  updatetime = 250,
  whichwrap = '<>[]hlbs',
}

local map = vim.keymap.set
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup(require 'plugins')
