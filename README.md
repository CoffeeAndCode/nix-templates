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

```sh
nix flake init -t github:coffeeandcode/nix-templates#ruby
nix run .#setup
git add .
nix develop
```
