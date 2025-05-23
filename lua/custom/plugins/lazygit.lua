-- lua/custom/plugins/lazygit.lua
-- This file configures the 'kdheepak/lazygit.nvim' plugin.
-- It provides integration with the lazygit terminal UI for Git.
return {
  'kdheepak/lazygit.nvim',
  cmd = { -- Commands to trigger loading of the plugin
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- Dependencies for lazygit.nvim:
  -- - telescope.nvim: Used for custom pickers and other advanced features within lazygit.nvim.
  -- - plenary.nvim: A common utility library used by many Neovim plugins, including Telescope.
  dependencies = {
    'nvim-telescope/telescope.nvim', 
    'nvim-lua/plenary.nvim', 
  },
  keys = {
    -- Keymap to open the LazyGit interface.
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'Open LazyGit' },
    -- You can add more keymaps here if desired, for example:
    -- { "<leader>gf", "<cmd>LazyGitCurrentFile<CR>", desc = "LazyGit Current File" },
  },
  -- opts = {} can be used here if specific configurations for lazygit.nvim are needed.
  -- For example, you might want to customize the floating window appearance or behavior.
  -- See :help lazygit.nvim-options for available settings.
}
