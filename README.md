### Installation
#### Git Submodules
This repo contains submodules, to init/fetch, use:
```sh
git submodule update --init --recursive
```
##### Dotfiles
Use `GNU Stow` to symlink dotfiles. Clone this repo to your home directory and use `stow`:

```
$ cd ~/dotfiles
$ stow [PACKAGE]
```

This will symlink the package's configuration files into the appropriate directories.

##### Brew
To install third-party packages listed in the `Brewfile` using `brew` on osx, run:

```
$ brew bundle
```

##### APT
Some additional symlinking may be required to get familiar package names
```
$ xargs -a <(awk '/^[^# ]/ { print $1 }' Aptfile) -- sudo apt install
```
