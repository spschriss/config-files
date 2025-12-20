# Configuration Files

## Setup

Install [nerd font](https://www.nerdfonts.com/)
Install [vim-plug](https://github.com/junegunn/vim-plug)

```sh
go install github.com/docker/docker-language-server/cmd/docker-language-server@latest
```

### On Mac

```sh
brew install node\
    go \
    docker-language-server \
    docker-compose-langserver \
    ripgrep \
    git
```

```sh
npm i -g vscode-langservers-extracted \
    vscode-eslint-language-server \
    @typescript/native-preview \
    vim-language-server
```

### On Linux

```sh
sudo apt update && \
    sudo apt upgrade && \
    sudo apt install golang-go \
        git
```

```sh
sudo apt-get install ripgrep
```

```sh
npm i -g vscode-langservers-extracted \
    @microsoft/compose-language-service \
    vscode-eslint-language-server \
    @typescript/native-preview \
    vim-language-server
```

## Language Servers

- [Lua](https://github.com/luals/lua-language-server)
- [Styla](https://github.com/JohnnyMorganz/StyLua)
- [Go](https://github.com/fatih/vim-go)
- [Typescript/Javascript](https://github.com/microsoft/typescript-go)
- [HTML](https://github.com/hrsh7th/vscode-langservers-extracted)
- [CSS](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#cssls)
- XML
- [JSON](https://github.com/hrsh7th/vscode-langservers-extracted)
- [docker compose language server](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#docker_compose_language_service)
- [docker-language-server](https://github.com/docker/docker-language-server)
- [eslint](https://github.com/hrsh7th/vscode-langservers-extracted)
- [Vim](https://github.com/iamcco/vim-language-server)

