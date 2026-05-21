# config-files

My NeoVim Configuration Setup

## How to Use


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

9. Install Plugins with `PlugInstall`
10. Happy Coding
