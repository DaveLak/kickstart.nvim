-- lua/custom/plugins/trouble.lua
-- This file configures the 'folke/trouble.nvim' plugin.
-- Trouble provides a pretty list for diagnostics, references, telescope results, quickfix and location lists.
return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- nvim-web-devicons for icons
  opts = {
    -- Configuration for Trouble.nvim.
    -- See :help trouble-options for more details.
    -- Leaving this empty uses default settings.
    -- Example:
    -- auto_open = false, -- Automatically open when diagnostics are present
    -- auto_close = true, -- Automatically close when there are no items
    -- use_diagnostic_signs = true, -- Show diagnostic signs in the trouble list
  },
  cmd = 'Trouble', -- Exposes the :Trouble command
  keys = {
    {
      -- Keymap to toggle the Trouble window.
      '<leader>xx',
      function()
        require('trouble').toggle()
      end,
      desc = 'Toggle Trouble diagnostics window',
    },
    {
      -- Keymap to toggle workspace diagnostics in Trouble.
      '<leader>xw',
      function()
        require('trouble').toggle 'workspace_diagnostics'
      end,
      desc = 'Toggle Workspace Diagnostics (Trouble)',
    },
    {
      -- Keymap to toggle document diagnostics in Trouble.
      '<leader>xd',
      function()
        require('trouble').toggle 'document_diagnostics'
      end,
      desc = 'Toggle Document Diagnostics (Trouble)',
    },
    {
      -- Keymap to toggle the quickfix list in Trouble.
      '<leader>xq',
      function()
        require('trouble').toggle 'quickfix'
      end,
      desc = 'Toggle Quickfix List (Trouble)',
    },
    {
      -- Keymap to toggle the location list in Trouble.
      '<leader>xl',
      function()
        require('trouble').toggle 'loclist'
      end,
      desc = 'Toggle Location List (Trouble)',
    },
    {
      -- Keymap to jump to the next Trouble item.
      -- `skip_groups = true` and `jump = true` ensures it jumps directly to the item.
      'gR',
      function()
        require('trouble').next { skip_groups = true, jump = true }
      end,
      desc = 'Next Trouble Item (jump)',
    },
    {
      -- Keymap to jump to the previous Trouble item.
      'gr',
      function()
        require('trouble').prev { skip_groups = true, jump = true }
      end,
      desc = 'Previous Trouble Item (jump)',
    },
  },
}
