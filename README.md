# config-files

My NeoVim Configuration Setup

## Key bindings

Leader key is `\` (Neovim default).

### LSP

| Key          | Action                       |
| ------------ | ---------------------------- |
| `grd`        | Go to declaration            |
| `grD`        | Go to definition             |
| `gri`        | Go to implementation         |
| `grr`        | Find references              |
| `grn`        | Rename symbol                |
| `g.`         | Code action                  |
| `K`          | Hover documentation          |
| `E`          | Show diagnostic in float     |
| `<C-k>`      | Signature help               |
| `<leader>D`  | Type definition              |
| `<leader>f`  | Format buffer                |
| `<leader>wa` | Add workspace folder         |
| `<leader>wr` | Remove workspace folder      |
| `<leader>wl` | List workspace folders       |

### Completion (nvim-cmp)

| Key         | Action                            |
| ----------- | --------------------------------- |
| `<C-Space>` | Trigger completion                |
| `<CR>`      | Confirm selection                 |
| `<Tab>`     | Next item / jump snippet forward  |
| `<S-Tab>`   | Prev item / jump snippet backward |
| `<C-b>`     | Scroll docs up                    |
| `<C-f>`     | Scroll docs down                  |
| `<C-e>`     | Abort completion                  |

### File explorer & Telescope

| Key          | Action            |
| ------------ | ----------------- |
| `<leader>e`  | Toggle NvimTree   |
| `<leader>ff` | Find files        |
| `<leader>fg` | Live grep         |
| `<leader>fb` | List open buffers |
| `<leader>fh` | Search help tags  |

### Claude Code

| Key          | Action                                 |
| ------------ | -------------------------------------- |
| `<leader>cc` | Toggle Claude terminal                 |
| `<leader>cf` | Focus the Claude window                |
| `<leader>cr` | Resume last session                    |
| `<leader>cC` | Continue most recent conversation      |
| `<leader>cb` | Add current buffer to Claude's context |
| `<leader>cs` | Send visual selection (visual mode)    |
| `<leader>ca` | Accept proposed diff                   |
| `<leader>cd` | Deny proposed diff                     |

### Comments

| Key             | Action                              |
| --------------- | ----------------------------------- |
| `gcc`           | Toggle current line as comment      |
| `gc` (visual)   | Toggle selection as comment         |
| `gcap`          | Toggle around paragraph             |
| `gbc`           | Toggle current line as block comment |

### Debugger (DAP)

| Key          | Action                          |
| ------------ | ------------------------------- |
| `<F5>`       | Continue / start debug session  |
| `<F10>`      | Step over                       |
| `<F11>`      | Step into                       |
| `<F12>`      | Step out                        |
| `<leader>db` | Toggle breakpoint               |
| `<leader>dB` | Conditional breakpoint (prompt) |
| `<leader>dr` | Open DAP REPL                   |
| `<leader>dl` | Re-run last debug session       |
| `<leader>du` | Toggle DAP UI panel             |
| `<leader>dt` | Terminate session               |

Available launch configs for `.ts` / `.js` / `.tsx` / `.jsx`:

1. **Launch current file (Node + tsx)** — runs the current file with `node --import=tsx`
2. **Attach to Node process (--inspect)** — pick a running Node process started with `--inspect`
3. **Debug Jest test (current file)** — runs `node_modules/.bin/jest --runInBand` on the current file
4. **Attach to Firefox tab** — prompts for the URL (defaults to `http://localhost:3000`); requires Firefox started with remote debugging enabled (see setup)

### Terminal

| Key     | Action                       |
| ------- | ---------------------------- |
| `<Esc>` | Exit terminal mode to normal |

## How to Use

### Quick Setup

1. Install your [nerdfont](https://www.nerdfonts.com/font-downloads) of choice
3. Clone this repository into your `~/.config/nvim` directory
3. Install homebrew dependencies `brew install ripgrep nvm neovim lemminx lua-language-server`
4. Install node with nvm `nvm install node`
5. Install langauge servers with npm

```sh
npm install -g typescript-language-server typescript vscode-langservers-extracted bash-language-server vim-language-server @angular/language-server some-sass-language-server
```

6. Install Claude cli `curl -fsSL https://claude.ai/install.sh | bash`
7. Install debug adapters (see [Debug adapters](#debug-adapters) below)
8. Install Plugins with `PlugInstall`
9. Happy Coding

### Detailed Setup

1. Install your [nerdfont](https://www.nerdfonts.com/font-downloads) of choice
2. Install neovim
3. Clone this repository into your `~/.config/nvim` directory

```sh
git clone https://github.com/spschriss/config-files ~/.config/nvim
```

4. Make sure you have the latest version of neovim installed

```sh
brew install neovim
```

5. Intall [vim-plug](https://github.com/junegunn/vim-plug#installation)
6. Install [ripgrep](https://github.com/BurntSushi/ripgrep#installation)

```sh
brew install ripgrep
```

7. Install language servers that ship as native binaries

```sh
brew install lemminx lua-language-server
```

   - `lemminx` — XML language server
   - `lua-language-server` — Lua language server

8. Make sure you have `nvm` installed and have the latest version of node installed

```sh
brew install nvm \
  && mkdir ~/.nvm \
  && nvm install node
```

9. Install language servers with npm

```sh
npm install -g typescript-language-server \
  typescript \
  vscode-langservers-extracted \
  bash-language-server \
  vim-language-server \
  @angular/language-server \
  some-sass-language-server
```

   - `typescript-language-server` + `typescript` — TypeScript & JavaScript
   - `vscode-langservers-extracted` — JSON, CSS/SCSS/LESS, HTML, ESLint
   - `bash-language-server` — Bash
   - `vim-language-server` — Vim script
   - `@angular/language-server` — Angular
   - `some-sass-language-server` — Sass (indented `.sass` syntax)

10. Install Claude cli

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

11. Install debug adapters (see [Debug adapters](#debug-adapters) below)
12. Install Plugins with `PlugInstall`
13. Happy Coding

### Debug adapters

The DAP debugger needs two external adapters installed in
`~/.local/share/nvim/debuggers/`. Both are built manually from source.

```sh
mkdir -p ~/.local/share/nvim/debuggers
cd ~/.local/share/nvim/debuggers

# Microsoft vscode-js-debug — Node / TypeScript / Jest
git clone https://github.com/microsoft/vscode-js-debug.git
cd vscode-js-debug
npm install
npx gulp vsDebugServerBundle
mv dist out
cd ..

# Mozilla vscode-firefox-debug — Firefox tab attach
git clone https://github.com/firefox-devtools/vscode-firefox-debug.git
cd vscode-firefox-debug
npm install
npm run build
```

To attach to a Firefox tab, launch Firefox with the remote debugger:

```sh
/Applications/Firefox.app/Contents/MacOS/firefox --start-debugger-server 6000
```

You'll also need `devtools.debugger.remote-enabled = true` in `about:config`.

For the "Launch current file (Node + tsx)" config, install `tsx` globally:

```sh
npm install -g tsx
```
