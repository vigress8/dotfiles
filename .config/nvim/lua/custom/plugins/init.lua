return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  { 'HiPhish/rainbow-delimiters.nvim' },
  {
    'mrcjkb/haskell-tools.nvim',
    version = '^3', -- Recommended
    ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
  },
  --	{
  --		"zeioth/garbage-day.nvim",
  --		dependencies = "neovim/nvim-lspconfig",
  --		event = "VeryLazy",
  --		opts = {},
  --	},
  {
    'onsails/lspkind.nvim',
    config = function()
      require('lspkind').init { mode = 'symbol_text' }
    end,
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    config = function()
      vim.keymap.set('n', '<leader>tt', require('trouble').toggle, { desc = 'Toggle Trouble window' })
    end,
  },
  {
    'Olical/conjure',
    ft = { 'python', 'racket' }, -- etc
    -- [Optional] cmp-conjure for cmp
    dependencies = {
      {
        'PaterJason/cmp-conjure',
        config = function()
          local cmp = require 'cmp'
          local config = cmp.get_config()
          table.insert(config.sources, {
            name = 'buffer',
            option = {
              sources = {
                { name = 'conjure' },
              },
            },
          })
          cmp.setup(config)
        end,
      },
    },
    config = function(_, opts)
      require('conjure.main').main()
      require('conjure.mapping')['on-filetype']()
    end,
    -- init = function()
    --   vim.g['conjure#debug'] = true
    -- end,
  },
  {
    'eraserhd/parinfer-rust',
    build = 'cargo build --release',
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
}
