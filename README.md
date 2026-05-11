# Configuration Files

## Setup

Install [nerd font](https://www.nerdfonts.com/)
Install [vim-plug](https://github.com/junegunn/vim-plug)

### On Mac

```sh
brew install node\
    docker-language-server \
    docker-compose-langserver \
    ripgrep \
    git \
    stylua \
    tree-sitter-cli \
    lua-language-server
```

```sh
npm i -g vscode-langservers-extracted \
    @microsoft/compose-language-service \
    typescript-language-server \
    vim-language-server
```

### On Linux

```sh
sudo apt update && \
    sudo apt upgrade && \
    sudo apt install \
        git \
        libc6 \
        libc6-dev \
        tree-sitter-cli \
        lua5.1 \
        ripgrep
```

```sh
npm i -g vscode-langservers-extracted \
    @microsoft/compose-language-service \
    typescript-language-server \
    vim-language-server 
```

## Language Servers

- [Lua](https://github.com/luals/lua-language-server)
- [Styla](https://github.com/JohnnyMorganz/StyLua)
- [Typescript/Javascript](https://github.com/microsoft/typescript-go)
- [HTML](https://github.com/hrsh7th/vscode-langservers-extracted)
- [CSS](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#cssls)
- XML
- [JSON](https://github.com/hrsh7th/vscode-langservers-extracted)
- [docker compose language server](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#docker_compose_language_service)
- [docker-language-server](https://github.com/docker/docker-language-server)
- [eslint](https://github.com/hrsh7th/vscode-langservers-extracted)
- [Vim](https://github.com/iamcco/vim-language-server)

