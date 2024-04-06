# Nix Templates

This repo contains useful templates for scaffolding various nix projects.

## Usage

You can install the template files by changing to your project
directory and then running one of:

```
nix flake init -t github:coffeeandcode/nix-templates#rails
nix flake init -t github:coffeeandcode/nix-templates#rails-devenv
nix flake init -t github:coffeeandcode/nix-templates#rails-shell
nix flake init -t github:coffeeandcode/nix-templates#ruby
nix flake init -t github:coffeeandcode/nix-templates#ruby-shell-temp
```

### Ruby Template

This uses a fork of bundix as the community library does not appear to be
maintained at the moment.

```sh
nix flake init -t github:coffeeandcode/nix-templates#ruby
nix run .#setup
git add .
nix develop
```

Example "rails new":

```sh
nix shell nixpkgs#rubyPackages.rails -c rails new example-app --skip-bundle
cd example-app
nix flake init -t github:coffeeandcode/nix-templates#ruby
# remove `windows` from the `debug` platforms list for now
# https://github.com/nix-community/bundix/pull/112
nix run .#setup
git add .
nix develop
```
