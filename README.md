# kickstart.nvim

## Introduction

A starting point for Neovim that is:

* Small
* Modular (core and plugin configurations are split into logical files)
* Completely Documented
* **Extensively pre-configured** with a wide array of Language Server Protocol (LSP) servers, linters, and formatters for many common languages and tools. These are automatically installed via Mason.

**NOT** a Neovim distribution, but instead a starting point for your configuration, now with even more batteries included!

## Features / Installed Tools

This configuration comes with a comprehensive set of tools pre-configured and managed by `mason.nvim` and `mason-tool-installer.nvim` for a rich out-of-the-box experience.

### Language Server Protocol (LSP) Servers

Provides code intelligence (completion, diagnostics, go-to-definition, etc.) for:

*   **JavaScript/TypeScript**: `ts_ls` (via `typescript-language-server`)
*   **Lua**: `lua_ls` (for Neovim's own configuration language)
*   **Python**: `ruff_lsp` (using Ruff's LSP capabilities)
*   **Go**: `gopls`
*   **Rust**: `rust_analyzer`
*   **YAML**: `yamlls` (with Kubernetes schema support by default)
*   **JSON**: `jsonls` (via `vscode-json-languageserver`)
*   **HTML**: `html` (via `vscode-html-languageserver-bin`)
*   **CSS/SCSS/Less**: `cssls` (via `vscode-css-languageserver-bin`)
*   **Terraform**: `terraformls`
*   **Dockerfiles**: `dockerls` (via `dockerfile-language-server`)
*   **SQL**: `sqlfluff` (general SQL LSP, also linter/formatter)
*   **PostgreSQL**: `postgresql_ls` (specific to PostgreSQL)
*   **TOML**: `taplo`
*   **Shell (Bash/Zsh)**: `bashls` (Bash), `zls` (Zsh)
*   **MDX**: `mdxls` (via `mdx-language-server`)
*   **Makefiles**: `makefls`
*   **OpenAPI**: `spectral_language_server`
*   **GraphQL**: `graphql` (via `graphql-language-server-cli`)
*   **Typst**: `typst_lsp`
*   **Emmet**: `emmet_ls` (for HTML-like expansions in various filetypes)

### Linters

Integrated via `nvim-lint` for on-the-fly code checking:

*   **JavaScript/TypeScript**: `eslint_d`
*   **Python**: `ruff`
*   **Shell (Bash/Sh/Zsh)**: `shellcheck`
*   **Terraform**: `tflint`
*   **Dockerfiles**: `hadolint`
*   **SQL**: `sqlfluff`
*   **Markdown**: `markdownlint-cli` (via `markdownlint`)
*   **.env files**: `dotenv-linter`

### Formatters

Integrated via `conform.nvim` for code formatting (often on save):

*   **Lua**: `stylua`
*   **Python**: `ruff_format` (using Ruff's formatting)
*   **Web files (JS, TS, JSX, TSX, CSS, HTML, JSON, YAML, Markdown, MDX, GraphQL)**: `prettier` (or `prettierd` if available)
*   **Terraform**: `terraformfmt` (native Terraform formatter)
*   **SQL**: `sqlfluff`

### Other Key Plugins

*   **`trouble.nvim`**: A pretty list for diagnostics, references, quickfix, and more.

## Installation

### Install Neovim

Kickstart.nvim targets *only* the latest
['stable'](https://github.com/neovim/neovim/releases/tag/stable) and latest
['nightly'](https://github.com/neovim/neovim/releases/tag/nightly) of Neovim.
If you are experiencing issues, please make sure you have the latest versions.

### Install External Dependencies

External Requirements:
- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation),
  [fd-find](https://github.com/sharkdp/fd#installation)
- Clipboard tool (xclip/xsel/win32yank or other depending on the platform)
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - if you have it set `vim.g.have_nerd_font` in `init.lua` to true
- Emoji fonts (Ubuntu only, and only if you want emoji!) `sudo apt install fonts-noto-color-emoji`
- Language Setup:
  - If you want to write Typescript, you need `npm`
  - If you want to write Golang, you will need `go`
  - etc.

> [!NOTE]
> See [Install Recipes](#Install-Recipes) for additional Windows and Linux specific notes
> and quick install snippets

### Install Kickstart

> [!NOTE]
> [Backup](#FAQ) your previous configuration (if any exists)

Neovim's configurations are located under the following paths, depending on your OS:

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%localappdata%\nvim\` |
| Windows (powershell)| `$env:LOCALAPPDATA\nvim\` |

#### Recommended Step

[Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) this repo
so that you have your own copy that you can modify, then install by cloning the
fork to your machine using one of the commands below, depending on your OS.

> [!NOTE]
> Your fork's URL will be something like this:
> `https://github.com/<your_github_username>/kickstart.nvim.git`

You likely want to remove `lazy-lock.json` from your fork's `.gitignore` file
too - it's ignored in the kickstart repo to make maintenance easier, but it's
[recommended to track it in version control](https://lazy.folke.io/usage/lockfile).

#### Clone kickstart.nvim

> [!NOTE]
> If following the recommended step above (i.e., forking the repo), replace
> `nvim-lua` with `<your_github_username>` in the commands below

<details><summary> Linux and Mac </summary>

```sh
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```
git clone https://github.com/nvim-lua/kickstart.nvim.git "%localappdata%\nvim"
```

If you're using `powershell.exe`

```
git clone https://github.com/nvim-lua/kickstart.nvim.git "${env:LOCALAPPDATA}\nvim"
```

</details>

### Post Installation

Start Neovim

```sh
nvim
```

That's it! Lazy will install all the plugins you have. Use `:Lazy` to view
the current plugin status. Hit `q` to close the window.

#### Read The Friendly Documentation

Read through the `init.lua` file and the files it loads (primarily in the
`lua/kickstart/` directory) in your configuration folder for more
information about extending and exploring Neovim. The main `init.lua` provides
an overview and loads core settings and plugins, which have their configurations
in `lua/kickstart/core/` and `lua/kickstart/plugins/` respectively.
This modular structure helps in organizing settings and plugins as your
configuration grows. The documentation also includes examples of adding
popularly requested plugins.

> [!NOTE]
> For more information about a particular plugin check its repository's documentation.


### Getting Started

[The Only Video You Need to Get Started with Neovim](https://youtu.be/m8C0Cq9Uv9o)

### FAQ

* What should I do if I already have a pre-existing Neovim configuration?
  * You should back it up and then delete all associated files.
  * This includes your existing init.lua and the Neovim files in `~/.local`
    which can be deleted with `rm -rf ~/.local/share/nvim/`
* Can I keep my existing configuration in parallel to kickstart?
  * Yes! You can use [NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME)`=nvim-NAME`
    to maintain multiple configurations. For example, you can install the kickstart
    configuration in `~/.config/nvim-kickstart` and create an alias:
    ```
    alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
    ```
    When you run Neovim using `nvim-kickstart` alias it will use the alternative
    config directory and the matching local directory
    `~/.local/share/nvim-kickstart`. You can apply this approach to any Neovim
    distribution that you would like to try out.
* What if I want to "uninstall" this configuration:
  * See [lazy.nvim uninstall](https://lazy.folke.io/usage#-uninstalling) information
* How is the Kickstart configuration structured?
  * Kickstart.nvim now adopts a modular structure by default. While it remains a
    teaching tool and a reference configuration, this modularity is introduced
    as a best practice for maintainability as your Neovim configuration grows.
  * The structure is as follows:
    * `init.lua`: This is still the main entry point for your Neovim configuration.
      However, it now primarily focuses on loading different modules and orchestrating
      the setup of core features and plugins. It's the place to get an overview of
      what's being loaded.
    * `lua/kickstart/core/`: This directory contains the base Neovim settings, broken
      down into logical files:
      * `options.lua`: General Neovim options (`vim.o` and `vim.g`).
      * `keymaps.lua`: Core (non-plugin) key mappings.
      * `autocommands.lua`: General (non-plugin) autocommands.
    * `lua/kickstart/plugins/`: This directory holds the configurations for the
      plugins that come with Kickstart. Each plugin, or a logical group of related
      plugins, has its own Lua file (e.g., `telescope.lua`, `lsp.lua`). This makes it
      easier to find and manage plugin settings.
    * `lua/custom/plugins/`: This directory is the recommended place for *you* to
      add your own unique plugins and their configurations. Kickstart can be configured
      to automatically load Lua files from this directory (see the `import = 'custom.plugins'`
      line in `init.lua`'s `lazy.setup` call). This keeps your personalizations separate
      from the base Kickstart configuration, making updates easier. You can see an example
      like `trouble.lua` in this directory.
  * This modular approach makes it easier to understand, manage, and extend your
    Neovim setup. You can easily find where specific settings or plugin configurations
    are located.

### Default Keybindings

This configuration sets up a few global keybindings for convenience:

*   `<leader>f`: Format buffer using `conform.nvim`.
*   `<leader>xx`: Toggle Trouble diagnostics window.
*   `<leader>xw`: Toggle Workspace Diagnostics in Trouble.
*   `<leader>xd`: Toggle Document Diagnostics in Trouble.
*   `<leader>xq`: Toggle Quickfix List in Trouble.
*   `<leader>xl`: Toggle Location List in Trouble.
*   `gR`: Go to next item in Trouble.
*   `gr`: Go to previous item in Trouble.

Many other keybindings are configured for specific plugins (like Telescope, LSP actions)
and can be found within their respective configuration files in `lua/kickstart/plugins/`
and `lua/kickstart/core/keymaps.lua`. `<leader>` is typically mapped to the `Space` key.

### Automation with Mason

All the listed LSPs, linters, and formatters are managed by `mason.nvim` and
`mason-tool-installer.nvim`. On the first run, these tools will be automatically
installed, providing a seamless setup experience. You can manage these tools
using the `:Mason` command.

* How do I add a new plugin?
  * **For personal use (recommended for most users):**
    1. Create a new Lua file in the `lua/custom/plugins/` directory (e.g., `lua/custom/plugins/my-new-plugin.lua`).
    2. In this file, return the plugin specification as required by `lazy.nvim`. For example:
       ```lua
       return {
         'username/my-new-plugin.nvim',
         -- Optional: add configuration like opts, event, dependencies, config function, etc.
         opts = {},
       }
       ```
    3. If you've uncommented the `{ import = 'custom.plugins' }` line in `init.lua`'s
       `lazy.setup` call, `lazy.nvim` will automatically pick up and load your new plugin
       file from `lua/custom/plugins/`.
    4. If you prefer to load plugins explicitly, you can `require` your new plugin
       configuration directly within the `plugins` table in `init.lua`'s `lazy.setup` call:
       ```lua
       -- In init.lua, inside the lazy.setup plugins table:
       require('custom.plugins.my-new-plugin'),
       ```
  * **To suggest a plugin for Kickstart itself (core plugins):**
    1. Create a new Lua file in `lua/kickstart/plugins/` (e.g., `lua/kickstart/plugins/new-core-plugin.lua`).
    2. Add the plugin specification in this file, similar to the example above.
    3. Then, add a `require` call for this new file in the main `init.lua` within the `lazy.setup` plugins table:
       ```lua
       -- In init.lua, inside the lazy.setup plugins table:
       require('kickstart.plugins.new-core-plugin'),
       ```
    (This is typically for contributions back to the Kickstart project).
### Install Recipes

Below you can find OS specific install instructions for Neovim and dependencies.

After installing all the dependencies continue with the [Install Kickstart](#Install-Kickstart) step.

#### Windows Installation

<details><summary>Windows with Microsoft C++ Build Tools and CMake</summary>
Installation may require installing build tools and updating the run command for `telescope-fzf-native`

See `telescope-fzf-native` documentation for [more details](https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation)

This requires:

- Install CMake and the Microsoft C++ Build Tools on Windows

```lua
{'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
```
</details>
<details><summary>Windows with gcc/make using chocolatey</summary>
Alternatively, one can install gcc and make which don't require changing the config,
the easiest way is to use choco:

1. install [chocolatey](https://chocolatey.org/install)
either follow the instructions on the page or use winget,
run in cmd as **admin**:
```
winget install --accept-source-agreements chocolatey.chocolatey
```

2. install all requirements using choco, exit the previous cmd and
open a new one so that choco path is set, and run in cmd as **admin**:
```
choco install -y neovim git ripgrep wget fd unzip gzip mingw make
```
</details>
<details><summary>WSL (Windows Subsystem for Linux)</summary>

```
wsl --install
wsl
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>

#### Linux Install
<details><summary>Ubuntu Install Steps</summary>

```
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>
<details><summary>Debian Install Steps</summary>

```
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip curl

# Now we install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# make it available in /usr/local/bin, distro installs to /usr/bin
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
```
</details>
<details><summary>Fedora Install Steps</summary>

```
sudo dnf install -y gcc make git ripgrep fd-find unzip neovim
```
</details>

<details><summary>Arch Install Steps</summary>

```
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim
```
</details>

