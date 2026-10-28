# nvim

My Neovim config: [LazyVim](https://www.lazyvim.org) plus a thin layer for the
languages I use (C++, Python, Rust, TypeScript/JavaScript, Java) and a
per-project code style switch (Google vs ROS 2).

LazyVim owns the plugin set, defaults and keybinds. This repo only adds what
differs from stock LazyVim, so upgrading LazyVim rarely breaks anything, and
every file in `lua/` explains why it exists.

## Install

```sh
# 1. Requirements (Ubuntu). Anything missing shows up in :checkhealth.
sudo apt install git ripgrep fd-find build-essential unzip clang-format lazygit
# Node (for TS/JS, prettier, eslint, a few language servers)
nvm install --lts
# Rust (rust-analyzer and rustfmt come with the toolchain)
curl https://sh.rustup.rs -sSf | sh
rustup component add rust-analyzer rustfmt
# Java (only if you need it): JDK 17+ on PATH for jdtls
sudo apt install openjdk-21-jdk

# 2. Neovim 0.11+. apt's is usually too old; use the AppImage.
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod +x nvim-linux-x86_64.appimage && sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim

# 3. This config
git clone git@github.com:CJBuchel/nvim.git ~/.config/nvim

# 4. First launch installs the plugins pinned in lazy-lock.json.
nvim
```

Language servers, formatters and linters are installed by Mason on first use of
each filetype. `:Mason` shows what's installed; `:LazyExtras` shows which
LazyVim language packs are enabled (they're listed in `lazyvim.json`).

## Updating

Updates are deliberate, never automatic. `lazy-lock.json` pins every plugin to
a commit, so every machine runs the same thing.

```
:Lazy update        # pull latest plugins, updates lazy-lock.json
                    # use it for a day, then commit lazy-lock.json
:Lazy restore       # roll back to whatever lazy-lock.json says
```

On a machine that is behind: `git pull` then `:Lazy restore`.

Updating LazyVim itself is the same: it's a plugin like any other. `:LazyHealth`
after an update catches most problems.

## Layout

```
init.lua                  loads config/lazy.lua, nothing else
lazyvim.json              which LazyVim extras (language packs) are on
lazy-lock.json            pinned plugin commits, committed
styles/clang-format/      google.clang-format, ros2.clang-format
lua/
  config/
    lazy.lua              lazy.nvim bootstrap and plugin spec roots
    options.lua           editor options, ROS filetypes
    keymaps.lua           VSCode-style aliases (see Keymaps)
    autocmds.lua          registers :CodeStyle
  util/
    codestyle.lua         decides which code style a buffer gets
  plugins/
    ui.lua                colorscheme, which-key, statusline
    lang/
      cpp.lua             clang-format, style-aware
      python.lua          pyright with pixi, black/isort or ruff by style
      java.lua            google-java-format
```

Rust, TypeScript/JavaScript, CMake, YAML, JSON, TOML, Docker and Markdown need
no file of their own; the LazyVim extras configure them fully. Add a file under
`lua/plugins/lang/` only when something should differ from the extra's default.

## Code style

Formatting (`<leader>cf`, or on save) picks a style per buffer:

1. **The project's own config wins.** A `.clang-format`, `pyproject.toml`,
   `.prettierrc` or `rustfmt.toml` found above the file is used as-is.
2. **Explicit override.** `:CodeStyle ros2` or `:CodeStyle google` for this
   session, `:CodeStyle auto` to go back to detection, `:CodeStyle` to ask.
   To pin a project, drop a `.nvim.lua` in its root:
   ```lua
   vim.g.code_style = "ros2"
   ```
   Neovim asks to trust the file once (`:trust`).
3. **Auto-detect.** A file inside a ROS 2 package (a `package.xml` above it)
   gets `ros2`.
4. **Default:** `google`.

| Style    | C/C++                              | Python                        |
| -------- | ---------------------------------- | ----------------------------- |
| `google` | Google, 100 cols, attached braces  | ruff (reads `pyproject.toml`) |
| `ros2`   | ament_clang_format (braces on own line, 100 cols) | isort + black, 99 cols |

Java is always google-java-format. TS/JS/CSS/HTML/Markdown/YAML/JSON are
always prettier. Rust is always rustfmt.

The statusline shows the active style for C/C++ and Python buffers, e.g.
`google (auto)` or `ros2`.

## Keymaps

`<leader>` is space. Press it and wait: which-key lists everything under it.
`<leader>?` lists every keybind for the current buffer. `<leader>sk` searches
all keymaps by name. When guessing, these three are faster than this README.

The VSCode-style keys in the right column are aliases added by this config.
The `<C-S-…>` and ``<C-`>`` ones need a terminal that supports the kitty
keyboard protocol (kitty, wezterm, ghostty); the `<leader>` keys always work.

### Finding things

| LazyVim           | VSCode-style | What                                              |
| ----------------- | ------------ | ------------------------------------------------- |
| `<leader><space>` |              | Find files (project root)                         |
| `<leader>ff`      |              | Find files (project root)                         |
| `<leader>fF`      | `<C-p>`      | Find files (cwd)                                  |
| `<leader>fr`      |              | Recent files                                      |
| `<leader>fg`      |              | Git-tracked files                                 |
| `<leader>fc`      |              | Find a file in this config                        |
| `<leader>fp`      |              | Projects                                          |
| `<leader>,`       |              | Open buffers                                      |
| `<leader>/`       |              | Grep (project root)                               |
| `<leader>sg`      |              | Grep (project root)                               |
| `<leader>sG`      | `<C-S-f>`    | Grep (cwd)                                        |
| `<leader>sw`      |              | Grep word under cursor / visual selection         |
| `<leader>sb`      |              | Fuzzy lines in current buffer                     |
| `<leader>sr`      |              | Search and replace across files (grug-far)        |
| `<leader>ss`      |              | Symbols in file (functions, classes, …)           |
| `<leader>sS`      |              | Symbols in workspace                              |
| `<leader>sd`      |              | All diagnostics                                   |
| `<leader>sR`      |              | Resume last picker                                |
| `<leader>sC`      | `<C-S-p>`    | Commands (command palette)                        |
| `<leader>sk`      |              | Keymaps                                           |
| `<leader>sh`      |              | Help pages                                        |
| `<leader>st`      |              | TODO / FIXME comments                             |
| `<leader>e`       | `<C-b>`      | File explorer (project root)                      |
| `<leader>E`       |              | File explorer (cwd)                               |

Inside any picker: type to filter, `<C-j>`/`<C-k>` or arrows to move, `<CR>`
to open, `<C-s>` split, `<C-v>` vsplit, `<C-q>` send all to quickfix, `<Esc>`
close. `?` shows the picker's own keys.

Inside the explorer: `a` add, `d` delete, `r` rename, `m` move, `y` copy path,
`.` set as root, `H` toggle hidden, `<CR>` open, `?` for the rest.

### Code (LSP)

| LazyVim           | VSCode-style | What                                              |
| ----------------- | ------------ | ------------------------------------------------- |
| `gd`              | `<F12>`      | Go to definition                                  |
| `gr`              | `<S-F12>`    | References                                        |
| `gI`              |              | Go to implementation                              |
| `gy`              |              | Go to type definition                             |
| `gD`              |              | Go to declaration                                 |
| `K`               |              | Hover docs                                        |
| `gK`, `<C-k>` (insert) |         | Signature help                                    |
| `<leader>ca`      | `<C-.>`      | Code action                                       |
| `<leader>cA`      |              | Source action (file-level fixes)                  |
| `<leader>cr`      | `<F2>`       | Rename symbol                                     |
| `<leader>cR`      |              | Rename file (updates imports)                     |
| `<leader>cf`      | `<S-A-f>`    | Format file / selection                           |
| `<leader>co`      |              | Organize imports                                  |
| `<leader>cd`      |              | Show diagnostic under cursor                      |
| `]d` / `[d`       | `<F8>` / `<S-F8>` | Next / previous diagnostic                   |
| `]e` / `[e`       |              | Next / previous error                             |
| `]]` / `[[`       |              | Next / previous reference to the word under cursor |
| `<leader>cs`      |              | Symbols outline (Trouble)                         |
| `<leader>xx`      |              | Diagnostics list (Trouble)                        |
| `<leader>xX`      |              | Diagnostics for this buffer                       |
| `<leader>cl`      |              | LSP info                                          |
| `<leader>cm`      |              | Mason (install language tools)                    |
| `<leader>uf`      |              | Toggle format-on-save (global)                    |
| `<leader>uF`      |              | Toggle format-on-save (this buffer)               |
| `<leader>uh`      |              | Toggle inlay hints                                |

Per language:

| Key               | Language | What                                              |
| ----------------- | -------- | ------------------------------------------------- |
| `<leader>ch`      | C/C++    | Switch between source and header                  |
| `<leader>cv`      | Python   | Select virtualenv                                 |
| `gR`              | TS/JS    | File references                                   |
| `<leader>cM`      | TS/JS    | Add missing imports                               |
| `<leader>cD`      | TS/JS    | Fix all diagnostics                               |
| `<leader>cV`      | TS/JS    | Select TypeScript version                         |
| `<leader>cxv`     | Java     | Extract variable                                  |
| `<leader>cxc`     | Java     | Extract constant                                  |
| `<leader>cgs`     | Java     | Go to super                                       |
| `<leader>tT`      | Java     | Run test                                          |
| `:CodeStyle`      | C++/Py   | Show or set the code style (see above)            |

Completion (blink.cmp): `<C-space>` open, `<C-n>`/`<C-p>` or `<Tab>`/`<S-Tab>`
move, `<CR>` accept, `<C-e>` close. Snippets expand with `<Tab>`.

### Editing

| Key                      | What                                            |
| ------------------------ | ----------------------------------------------- |
| `<C-s>`                  | Save                                            |
| `<A-j>` / `<A-k>`        | Move line / selection down / up                 |
| `<A-Down>` / `<A-Up>`    | Same, on arrows (this config)                   |
| `gcc`, `gc` + motion     | Toggle comment                                  |
| `gco` / `gcO`            | Add comment line below / above                  |
| `s` + two chars          | Jump anywhere on screen (flash)                 |
| `S`                      | Select a treesitter node (flash)                |
| `<C-space>`              | Incremental selection (expand by syntax node)   |
| `gsa` / `gsd` / `gsr`    | Add / delete / replace surrounding quotes, brackets (mini.surround) |
| `<leader>ss`             | Jump to a function / class in this file         |
| `]f` / `[f`              | Next / previous function start                  |
| `]c` / `[c`              | Next / previous class start                     |
| `]t` / `[t`              | Next / previous TODO comment                    |
| `<leader>us`             | Toggle spell check                              |
| `<leader>uw`             | Toggle line wrap                                |

Text objects from mini.ai and treesitter work with any operator (`d`, `c`, `y`,
`v`): `af`/`if` function, `ac`/`ic` class, `aa`/`ia` argument, `ao`/`io`
block/loop/conditional, plus `a"`, `i(`, `it`, etc.

### Windows, buffers, tabs

| Key                      | What                                            |
| ------------------------ | ----------------------------------------------- |
| `<C-h/j/k/l>`            | Move between windows                            |
| `<C-Up/Down/Left/Right>` | Resize window                                   |
| `<leader>-` / `<leader>\|` | Split below / right                           |
| `<leader>wd`             | Close window                                    |
| `<leader>wm`             | Maximize / restore window                       |
| `<C-w><space>`           | Window menu (which-key hydra)                   |
| `<S-h>` / `<S-l>`        | Previous / next buffer                          |
| `<leader>bd`             | Close buffer (keeps window)                     |
| `<leader>bo`             | Close other buffers                             |
| `<leader>bp`             | Pin buffer                                      |
| `` <leader>` ``          | Switch to last buffer                           |
| `<leader><tab><tab>`     | New tab                                         |
| `<leader><tab>]` / `[`   | Next / previous tab                             |
| `<leader><tab>d`         | Close tab                                       |

### Git

| Key               | What                                                      |
| ----------------- | --------------------------------------------------------- |
| `<leader>gg`      | Lazygit                                                   |
| `<leader>gs`      | Git status (changed files picker)                         |
| `<leader>gd`      | Git diff (hunks picker)                                   |
| `<leader>gb`      | Blame current line                                        |
| `<leader>gf`      | History of current file                                   |
| `<leader>gl`      | Git log                                                   |
| `<leader>gB`      | Open file on GitHub in browser                            |
| `]h` / `[h`       | Next / previous changed hunk                              |
| `<leader>ghp`     | Preview hunk                                              |
| `<leader>ghr`     | Reset hunk                                                |
| `<leader>ghs`     | Stage hunk                                                |

### Terminal, sessions, misc

| Key               | What                                                      |
| ----------------- | --------------------------------------------------------- |
| `<C-/>`, ``<C-`>`` | Toggle floating terminal (same key hides it again)      |
| `<leader>ft`      | Terminal at project root                                  |
| `<leader>qs`      | Restore last session for this directory                   |
| `<leader>qq`      | Quit all                                                  |
| `<leader>l`       | Lazy (plugin manager)                                     |
| `<leader>L`       | LazyVim changelog                                         |
| `<leader>uC`      | Pick colorscheme                                          |
| `<leader>un`      | Dismiss notifications                                     |
| `<leader>z`       | Zen mode                                                  |
| `<Esc>`           | Clear search highlight                                    |
| `:checkhealth`    | What's installed, missing, or broken                      |
