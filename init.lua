--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read this `init.lua` file, and then explore the files
    it loads in `lua/kickstart/` to understand what your configuration is doing,
    and how to modify it to suit your needs.

    Kickstart.nvim is now structured modularly:
      - `init.lua`: This file, the main entry point. It handles basic setup and
        loads core settings and plugins.
      - `lua/kickstart/core/`: Contains base Neovim configurations for options,
        keymaps, and autocommands.
      - `lua/kickstart/plugins/`: Contains configurations for each plugin.
      - `lua/custom/plugins/`: The recommended place for your personal plugin
        configurations.

    Once you've familiarized yourself with this structure, you can start
    exploring, configuring, and tinkering to make Neovim your own!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** this
  `init.lua` file and the files it loads (primarily in `lua/kickstart/`).

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout this `init.lua` file and the
  files in `lua/kickstart/`. These are hints about where to find more information
  about the relevant settings, plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this (i.e. `NOTE:`)

    Throughout the configuration. These are for you, the reader, to help you understand
    what is happening. Feel free to delete them once you know what you're doing, but they
    should serve as a guide for when you are first encountering a few different constructs
    in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Load core configuration modules
-- Each file in `lua/kickstart/core/` is responsible for a specific set of settings.
-- For example, `options.lua` sets Neovim options, `keymaps.lua` defines core keybindings.

-- Load core Neovim settings (options, globals)
-- NOTE: `options.lua` must be loaded first to ensure `vim.g.mapleader` is set
-- before other modules or plugins try to use it.
require 'kickstart.core.options'

-- Load basic keymaps
require 'kickstart.core.keymaps'

-- Load basic autocommands
require 'kickstart.core.autocommands'

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
--  Kickstart uses `lazy.nvim` (https://github.com/folke/lazy.nvim) as a plugin manager.
--  You can learn more about managing plugins with `lazy.nvim` by reading its documentation.
--
--  The lines below are requiring plugin configuration files from the `lua/kickstart/plugins/` directory.
--  Each file in that directory returns a table that conforms to `lazy.nvim`'s plugin specification.
--  See `:help lazy.nvim-plugin-spec` for more details.
--
--  If you want to add your own plugins, the easiest way is to create a new file in `lua/custom/plugins/`
--  (e.g., `lua/custom/plugins/my-plugin.lua`) and add your plugin specification there.
--  Then, you can uncomment the `{ import = 'custom.plugins' }` line below.
--  This will automatically load all files from `lua/custom/plugins/*.lua` and `lua/custom/plugins/*.init.lua`.
--
--  If you prefer, you can also add your plugin specifications directly in this `lazy.setup` call.
require('lazy').setup({
  -- Load plugin configurations from individual files in `lua/kickstart/plugins/`
  require 'kickstart.plugins.guess-indent', -- Detects indentation settings automatically
  require 'kickstart.plugins.gitsigns', -- Adds git related signs to the gutter
  require 'kickstart.plugins.which-key', -- Shows pending keybinds
  require 'kickstart.plugins.telescope', -- Fuzzy finder
  require 'kickstart.plugins.lsp', -- Language Server Protocol configurations
  require 'kickstart.plugins.conform', -- Auto-formatting
  require 'kickstart.plugins.completion', -- Autocompletion setup
  require 'kickstart.plugins.colorscheme', -- The colorscheme (tokyonight)
  require 'kickstart.plugins.todo-comments', -- Highlights TODO, FIXME, etc.
  require 'kickstart.plugins.mini', -- Collection of minimal Lua plugins
  require 'kickstart.plugins.treesitter', -- Treesitter configuration for syntax highlighting, etc.

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted this
  -- init.lua file. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository but are disabled by default.
  --  Uncomment any of the lines below to enable them. Your configurations should be placed in `lua/custom/plugins/`.
  --  See the README for more information on how to add plugins.
  --
  -- require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- For more gitsigns configuration, see `lua/kickstart/plugins/gitsigns.lua`

  -- NOTE: The import below can automatically add your own plugins, configuration, etc., from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your personal config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For example, create a file `lua/custom/plugins/foo.lua` and add plugin specs to that file.
  { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-lazy.nvim-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
