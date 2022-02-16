# Nix Templates

This repo contains useful templates for scaffolding various nix projects.

## Example

Create a flake based on the `ruby-temp` template in the current directory:

```
nix flake init -t github:coffeeandcode/nix-templates#rails
nix flake init -t github:coffeeandcode/nix-templates#rails-shell
nix flake init -t github:coffeeandcode/nix-templates#ruby-shell-temp
```
