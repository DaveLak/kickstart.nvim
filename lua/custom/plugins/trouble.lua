-- lua/custom/plugins/trouble.lua
return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  cmd = 'Trouble',
  keys = {
    {
      '<leader>xx',
      function()
        require('trouble').toggle()
      end,
      desc = 'Toggle Trouble',
    },
    {
      '<leader>xw',
      function()
        require('trouble').toggle 'workspace_diagnostics'
      end,
      desc = 'Workspace Diagnostics (Trouble)',
    },
    {
      '<leader>xd',
      function()
        require('trouble').toggle 'document_diagnostics'
      end,
      desc = 'Document Diagnostics (Trouble)',
    },
    {
      '<leader>xq',
      function()
        require('trouble').toggle 'quickfix'
      end,
      desc = 'Quickfix List (Trouble)',
    },
    {
      '<leader>xl',
      function()
        require('trouble').toggle 'loclist'
      end,
      desc = 'Location List (Trouble)',
    },
    {
      'gR',
      function()
        require('trouble').next { skip_groups = true, jump = true }
      end,
      desc = 'Next Trouble Item',
    },
    {
      'gr',
      function()
        require('trouble').prev { skip_groups = true, jump = true }
      end,
      desc = 'Previous Trouble Item',
    },
  },
}
