### Installation
##### Brew
To install third-party packages listed in the `Brewfile` using `brew` on osx, run:

```
$ brew bundle
```

##### Dotfiles
Use `GNU Stow` to symlink dotfiles. Clone this repo to your home directory and use `stow`:

```
$ cd ~/dotfiles
$ stow [PACKAGE]
```

This will symlink the package's configuration files into the appropriate directories.

-----

### Configs
##### VIM
`:PlugInstall` to install external plugins using `vim-plug`.

##### ZSH
To source optional files in an interactive shell: `touch $HOME/.zsh/opt/myoptionalfile.zsh`
Good for machine specific config/env, like for a work computer or config that doesn't need to be committed here.

