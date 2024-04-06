{
  description = "project-name";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    ruby-nix.url = "github:inscapist/ruby-nix";
    ruby-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ruby-nix }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = function: nixpkgs.lib.genAttrs systems (system:
        function (import nixpkgs {
          inherit system;
        }));
    in
    {
      apps = forAllSystems (pkgs:
        {
          bundler = {
            type = "app";
            program = "${pkgs.bundler}/bin/bundler";
          };
          bundix = {
            type = "app";
            program = "${pkgs.bundix}/bin/bundix";
          };
        });

      devShells = forAllSystems
        (pkgs:
          let
            rubyNix = ruby-nix.lib pkgs;
            gemset =
              if builtins.pathExists ./gemset.nix then import ./gemset.nix else { };
            # If you want to override gem build config, see
            #   https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/ruby-modules/gem-config/default.nix
            gemConfig = { };
            inherit (rubyNix {
              inherit gemset;
              name = "project-name";
              gemConfig = pkgs.defaultGemConfig // gemConfig;
              ruby = pkgs.ruby;
            })
              env;
          in
          {
            default = pkgs.mkShell
              {
                buildInputs = [ env ];
              };
          });

      packages = forAllSystems (pkgs:
        {
          setup = pkgs.writeShellApplication
            {
              name = "setup";
              runtimeInputs = [ pkgs.bundix pkgs.bundler ];
              text = ''
                echo "Forcing 'ruby' platform with bundler"
                bundle config --local force_ruby_platform true

                echo "Adding 'ruby' platform and generating Gemfile.lock"
                bundle lock --add-platform ruby

                echo "Generating gemset.nix"
                bundix -l

                echo "Ready to run \`nix develop\`"
              '';
            };
        });
    };
}
