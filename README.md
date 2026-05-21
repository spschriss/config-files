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

### Terminal

| Key     | Action                       |
| ------- | ---------------------------- |
| `<Esc>` | Exit terminal mode to normal |

## How to Use

### Quick Setup

1. Install your [nerdfont](https://www.nerdfonts.com/font-downloads) of choice
3. Clone this repository into your `~/.config/nvim` directory
3. Install homebrew dependencies `brew install ripgrep nvm neovim`
4. Install node with nvm `nvm install node`
5. Install langauge servers with npm 

```sh
npm install -g typescript-language-server typescript vscode-langservers-extracted bash-language-server
```

6. Install Claude cli `curl -fsSL https://claude.ai/install.sh | bash`
7. Install Plugins with `PlugInstall`
8. Happy Coding

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

7. Make sure you have `nvm` installed and have the latest version of node installed

```sh
brew install nvm \
  && mkdir ~/.nvm \
  && nvm install node
```

8. Install langauge servers with npm

```sh
npm install -g typescript-language-server \
  typescript \
  vscode-langservers-extracted \
  bash-language-server
```

9. Install Claude cli

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

9. Install Plugins with `PlugInstall`
10. Happy Coding
