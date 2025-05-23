-- Configures conform.nvim for auto-formatting.
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    -- Configures format_on_save behavior.
    -- Uses a function to dynamically determine if formatting should occur.
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true } -- Example: disable for C and C++
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil -- No formatting for disabled filetypes
      else
        -- For other filetypes, configure format_on_save with a timeout
        -- and use LSP formatting as a fallback if conform.nvim fails.
        return {
          timeout_ms = 500, -- Max time in milliseconds for formatting
          lsp_format = 'fallback', -- Use LSP formatter if conform.nvim fails
        }
      end
    end,
    -- Defines formatters by filetype.
    -- Conform.nvim will attempt to use these formatters in the order specified.
    formatters_by_ft = {
      lua = { 'stylua' }, -- Lua
      python = { 'ruff_format' }, -- Python, using ruff's formatting capabilities

      -- Web development filetypes, primarily using Prettier.
      -- 'prettierd' is preferred for performance (runs as a daemon).
      -- If 'prettierd' is not available, it falls back to 'prettier'.
      -- 'stop_after_first = true' ensures only the first available formatter is used.
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true }, -- JSX
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true }, -- TSX
      vue = { 'prettierd', 'prettier', stop_after_first = true }, -- Vue
      json = { 'prettierd', 'prettier', stop_after_first = true }, -- JSON
      yaml = { 'prettierd', 'prettier', stop_after_first = true }, -- YAML
      markdown = { 'prettierd', 'prettier', stop_after_first = true }, -- Markdown
      css = { 'prettierd', 'prettier', stop_after_first = true }, -- CSS
      html = { 'prettierd', 'prettier', stop_after_first = true }, -- HTML
      mdx = { 'prettierd', 'prettier', stop_after_first = true }, -- MDX
      graphql = { 'prettierd', 'prettier', stop_after_first = true }, -- GraphQL

      -- Infrastructure and DevOps
      terraform = { 'terraformfmt' }, -- Terraform native formatter
      tf = { 'terraformfmt' }, -- Also for .tf files

      -- SQL
      sql = { 'sqlfluff' }, -- SQLFluff for SQL formatting

      -- Example of how to configure multiple formatters if needed for other languages:
      -- For instance, for C, you might use clang-format.
      -- c = { "clang-format" },
    },
  },
}
