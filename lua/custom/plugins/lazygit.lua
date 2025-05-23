-- lua/custom/plugins/lazygit.lua
return {
  'kdheepak/lazygit.nvim',
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- Optional: Add dependencies like `nvim-lua/plenary.nvim` if not already present elsewhere
  -- and `nvim-telescope/telescope.nvim` for custom integration, but often not strictly needed for basic use.
  -- For now, we'll keep it simple.
  dependencies = {
    'nvim-telescope/telescope.nvim', -- Often useful for advanced lazygit commands
    'nvim-lua/plenary.nvim', -- Common utility
  },
  keys = {
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    -- You can add more keymaps here if desired, e.g., for specific LazyGit commands
  },
  -- You can add opts = {} here if specific lazygit.nvim configurations are needed
}
