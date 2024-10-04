# .files

my dotfiles

## requirements

- [ ] neovim installed (globally or to `$HOME/.local/bin/nvim`)
- [ ] fzf installed
- [ ] ripgrep installed

## apt dependencies

```sh
xargs sudo apt install -y < $HOME/.files/deb-requirements.txt
```

## install

1. Clone this repo to the `$HOME` folder.
2. `stow .` inside the folder.
