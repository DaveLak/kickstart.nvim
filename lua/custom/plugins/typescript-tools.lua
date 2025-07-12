return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    settings = {
      expose_as_code_action = 'all',
      complete_function_calls = true,
      include_completions_with_insert_text = true,
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'none',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = false,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayEnumMemberValueHints = false,
        importModuleSpecifierPreference = 'non-relative',
        includeCompletionsForModuleExports = true,
        quotePreference = 'auto',
      },
      tsserver_format_options = {
        allowIncompleteCompletions = false,
        allowRenameOfImportPath = false,
      },
    },
    on_attach = function(client, bufnr)
      local wk = require 'which-key'
      local bufopts = { noremap = true, silent = true, buffer = bufnr }

      -- It's good practice to map Go-to-Definition variants to `g` keys
      vim.keymap.set('n', 'gD', '<cmd>TSToolsGoToSourceDefinition<cr>', bufopts)

      wk.add {
        -- Code Actions
        { '<leader>c', group = 'Code' },
        { '<leader>ca', '<cmd>TSToolsAddMissingImports<cr>', desc = 'Add missing imports' },
        { '<leader>cf', '<cmd>TSToolsFixAll<cr>', desc = 'Fix all errors' },
        { '<leader>ci', '<cmd>TSToolsRemoveUnusedImports<cr>', desc = 'Remove unused imports' },
        { '<leader>co', '<cmd>TSToolsOrganizeImports<cr>', desc = 'Organize imports' },
        { '<leader>cs', '<cmd>TSToolsSortImports<cr>', desc = 'Sort imports' },
        { '<leader>cu', '<cmd>TSToolsRemoveUnused<cr>', desc = 'Remove all unused statements' },

        -- Refactor
        { '<leader>r', group = 'Refactor' },
        { '<leader>rr', '<cmd>TSToolsRenameFile<cr>', desc = 'Rename file' },

        -- Find
        { '<leader>f', group = 'Find' },
        { '<leader>fr', '<cmd>TSToolsFileReferences<cr>', desc = 'Find file references' },
      }
    end,
  },
  ft = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
}
