-- Configures linting using nvim-lint.
return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      -- lint.linters_by_ft = {
      --   markdown = { 'markdownlint' },
      -- }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- This pattern allows overriding or adding linters by filetype.
      -- If `lint.linters_by_ft` already exists, it uses that table; otherwise, it creates a new one.
      -- This makes the configuration extensible and allows other plugins or user configs to add more linters.
      lint.linters_by_ft = lint.linters_by_ft or {}

      -- General web and text file linters
      lint.linters_by_ft.markdown = { 'markdownlint' } -- Markdown style and syntax
      lint.linters_by_ft.dotenv = { 'dotenv-linter' } -- Linting for .env files

      -- Shell script linters
      lint.linters_by_ft.sh = { 'shellcheck' } -- General shell scripts
      lint.linters_by_ft.bash = { 'shellcheck' } -- Bash specific
      lint.linters_by_ft.zsh = { 'shellcheck' } -- Zsh specific (shellcheck handles different shell dialects)

      -- JavaScript/TypeScript and related frameworks
      lint.linters_by_ft.javascript = { 'eslint_d' } -- Using eslint_d for faster linting
      lint.linters_by_ft.typescript = { 'eslint_d' }
      lint.linters_by_ft.javascriptreact = { 'eslint_d' } -- For JSX
      lint.linters_by_ft.typescriptreact = { 'eslint_d' } -- For TSX
      lint.linters_by_ft.vue = { 'eslint_d' } -- For Vue.js single-file components

      -- Python
      lint.linters_by_ft.python = { 'ruff' } -- Fast Python linter and formatter

      -- Infrastructure and DevOps
      lint.linters_by_ft.terraform = { 'tflint' } -- Terraform linter
      lint.linters_by_ft.tf = { 'tflint' } -- Also for .tf files (common extension)
      lint.linters_by_ft.dockerfile = { 'hadolint' } -- Dockerfile linter

      -- SQL
      lint.linters_by_ft.sql = { 'sqlfluff' } -- SQL linter and formatter

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
