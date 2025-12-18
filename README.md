# neovim-config

Configuration files for neovim

## Dependencies

### Version Control

- Must have [Git](https://git-scm.com/) installed

### Package Managers

- Must have [vim-plug](https://github.com/junegunn/vim-plug) installed
- Must have [Node](https://nodejs.org/en) version 20+ install
- Must have gcc installed `sudo apt install gcc`

### Theme

- Must have a [Nerd Font](https://www.nerdfonts.com/font-downloads) installed
- Terminal must support 256 color mode

### Language Servers

- [Install Golang](https://go.dev/doc/install)
   - Add `export PATH=$PATH:$HOME/go/bin` to your `.bashrc` on Linux or `.zshrc` on MacOS
- [Install NodeJS](https://nodejs.org/en)
- Must have [Lua Language Server](https://luals.github.io/#install) installed

**Install Language Servers**

```sh
npm i -g vim-language-server \
  typescript \
  typescript-language-server \
  eslint \
  prettier \
  jest \
  ts-jest \
  @microsoft/compose-language-service \
  @angular/language-service \
  vscode-langservers-extracted \
  graphql-language-service-cli \
  @johnnymorganz/stylua-bin \
  @tailwindcss/language-server \
  @vue/language-server
```

**Install Build Tools**

```sh
go install golang.org/x/tools/gopls@latest && \
  go install github.com/shurcooL/markdownfmt@latest && \
  go install github.com/docker/docker-language-server/cmd/docker-language-server@latest && \
  go install github.com/sqls-server/sqls@latest && \
  go install github.com/go-delve/delve/cmd/dlv@latest
```

- Must have go [delve](https://github.com/go-delve/delve/tree/master/Documentation/installation)
- Must have the [vs-code-language-servers-extended](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#cssls) installed for CSS, Javascript, and HTML

## Next Steps

- Read https://langserver.org/
