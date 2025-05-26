-- Configures LSP (Language Server Protocol) support and related plugins.
return {
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --
        -- LSP server for TypeScript and JavaScript
        tsserver = { -- Changed from ts_ls to tsserver to match common lspconfig name for typescript-language-server
          -- Optional: Disable tsserver formatting if using conform.nvim with prettier
          -- This allows Prettier to take over formatting duties for JS/TS.
          settings = {
            typescript = {
              format = {
                enable = false,
              },
            },
            javascript = {
              format = {
                enable = false,
              },
            },
          },
          -- To use eslint_d for diagnostics and code actions instead of tsserver's built-in linting
          -- you might need to configure it further, potentially using null-ls or a dedicated eslint plugin,
          -- or by configuring tsserver to play nicely with external eslint.
          -- For now, default tsserver diagnostics will be active alongside external eslint_d from nvim-lint.
        },

        emmet_ls = {}, -- HTML/CSS/JSX/TSX emmet support (e.g. div.foo>span#bar)

        lua_ls = { -- Lua language server
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        -- Add yamlls
        yamlls = { -- YAML language server
          settings = {
            yaml = {
              schemas = {
                ["kubernetes"] = "/*.(yml|yaml)", 
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/composer.json"] = "/composer.json",
              },
              format = {
                enable = false, 
              },
              validate = true, 
            },
          },
        },
        jsonls = { -- JSON language server (Mason: json-lsp)
        },
        -- Python: pyright is used instead of ruff-lsp for LSP features.
        -- Ruff is still used for linting and formatting.
        pyright = { -- Python LSP (Mason: pyright)
        },
        taplo = { -- TOML language server (Mason: taplo)
        },
        gopls = { -- Go language server
          -- Example settings for gopls:
          -- settings = {
          --   gopls = {
          --     analyses = {
          --       unusedparams = true,
          --     },
          --     staticcheck = true,
          --   },
          -- },
        },
        rust_analyzer = { -- Rust language server
          -- Example settings for rust_analyzer:
          -- settings = {
          --   ['rust-analyzer'] = { -- Note: settings table uses 'rust-analyzer' as key
          --     checkOnSave = { command = "clippy" }, -- Example: Use clippy for checks on save
          --   },
          -- },
        },
        bashls = { -- Bash language server
        },
        zls = { -- Zsh language server
          -- If zsh-language-server is not found by Mason, this server setup will effectively be a no-op for zls.
        },
        cssls = { -- CSS language server (Mason: css-lsp)
        },
        html = { -- HTML language server (Mason: html-lsp)
        },
        terraformls = { -- Terraform language server (Mason: terraform-ls)
        },
        dockerls = { -- Dockerfile language server (Mason: dockerfile-language-server)
        },
        sqlfluff = { -- SQLFluff LSP for SQL linting and formatting (Mason: sqlfluff)
        },
        mdx_analyzer = { -- MDX language server (Mason: mdx-analyzer)
        },
        -- makefls was removed
        spectral = { -- OpenAPI/Swagger linter (Mason: spectral-language-server)
          -- filetypes = { "yaml", "json" } 
        },
        graphql = { -- GraphQL language server (Mason: graphql-language-server-cli)
        },
        postgres_lsp = { -- PostgreSQL language server (Mason: postgrestools)
        },
        tinymist = { -- Typst language server (Mason: tinymist)
        },
      }

      -- Ensure the servers and tools above are installed
      --  This uses the vim.tbl_keys function to get all the keys from the `servers` table.
      --  The `vim.list_extend` function then adds other tools that Mason should install.
      --  These tools include formatters, linters, and other utilities.
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.

      -- Ensure the servers and tools are installed by Mason.
      -- This is a flat list of actual Mason package names.
      local ensure_installed_mason_packages = {
        -- Linters, Formatters, and other Tools (not primarily LSPs)
        'stylua',             -- Lua formatter
        'shellcheck',         -- Shell script linter
        'eslint_d',           -- JavaScript/TypeScript linter (daemonized) - Consider eslint-lsp if issues
        'prettier',           -- General purpose formatter (changed from prettierd)
        'ruff',               -- Python linter and formatter tool
        'markdownlint',       -- Markdown linter
        'tflint',             -- Terraform linter
        'hadolint',           -- Dockerfile linter
        'dotenv-linter',      -- .env file linter

        -- Mason Package Names for LSP Servers
        -- (Aligned with the user-provided list and common Mason package names)
        'lua-language-server',         -- for lua_ls
        'typescript-language-server',  -- for tsserver (LSP name for ts_ls)
        'emmet-ls',                    -- for emmet_ls
        'yaml-language-server',        -- for yamlls
        'json-lsp',                    -- for jsonls (changed from vscode-json-languageserver)
        'pyright',                     -- for pyright (Python LSP, changed from ruff-lsp)
        'taplo',                       -- for taplo (TOML)
        'gopls',                       -- for gopls (Go)
        'rust-analyzer',               -- for rust_analyzer (Rust)
        'bash-language-server',        -- for bashls
        'zsh-language-server',         -- for zls
        'css-lsp',                     -- for cssls (changed from vscode-css-languageserver-bin)
        'html-lsp',                    -- for html (changed from vscode-html-languageserver-bin)
        'terraform-ls',                -- for terraformls
        'dockerfile-language-server',  -- for dockerls
        'sqlfluff',                    -- for sqlfluff (LSP, linter, formatter for SQL)
        'mdx-analyzer',                -- for mdx_analyzer (changed from mdx-language-server)
        -- 'makefls' was removed
        'spectral-language-server',    -- for spectral (LSP name for spectral_language_server)
        'graphql-language-server-cli', -- for graphql
        'postgrestools',               -- for postgres_lsp (changed from postgresql-language-server)
        'tinymist',                    -- for tinymist (Typst LSP, changed from typst-lsp)
      }

      -- Remove duplicates to ensure each package is listed only once for mason-tool-installer.
      -- This is important if a tool serves multiple roles (e.g., sqlfluff as LSP and linter).
      local unique_packages = {}
      local final_ensure_installed = {}
      for _, pkg in ipairs(ensure_installed_mason_packages) do
        if not unique_packages[pkg] then
          table.insert(final_ensure_installed, pkg)
          unique_packages[pkg] = true
        end
      end

      require('mason-tool-installer').setup { 
        ensure_installed = final_ensure_installed 
      }

      require('mason-lspconfig').setup {
        -- NOTE: `ensure_installed` for `mason-lspconfig` CAN take lspconfig server names.
        -- However, since we are using `mason-tool-installer` to handle all installations,
        -- this `ensure_installed` should be empty. `mason-tool-installer` has already
        -- been triggered with the explicit Mason package names.
        ensure_installed = {}, -- Explicitly empty as mason-tool-installer handles all installations.
        automatic_installation = false, -- Keep false as mason-tool-installer is the primary installer.
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
