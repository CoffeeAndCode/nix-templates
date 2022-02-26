{
  description = "project-name";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        unfree_pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };
        ruby = pkgs.ruby;
        bundler = pkgs.buildRubyGem rec {
          inherit ruby;
          name = "${gemName}-${version}";
          gemName = "bundler";
          version = "2.3.6";
          source = {
            remotes = [ "https://rubygems.org" ];
            sha256 = "1531z805j3gls2x0pqp2bp1vv1rf5k7ynjl4qk72h8lpm1skqk9r";
            type = "gem";
          };
        };
        gems = pkgs.bundlerEnv.override { inherit bundler; } {
          inherit ruby;
          name = "project-name";
          gemdir = ./.;
        };
      in {
        apps = {
          brakeman = {
            type = "app";
            program = "${unfree_pkgs.brakeman}/bin/brakeman";
          };

          bundler = {
            type = "app";
            program = "${bundler}/bin/bundler";
          };
        };
        devShell = pkgs.mkShell {
          name = "project-name";

          buildInputs = with pkgs; [
            (bundix.override { inherit bundler; })
            gems
            gems.wrappedRuby
            nixfmt
            nodejs-16_x
            (yarn.override { nodejs = nodejs-16_x; })
          ];
        };
      });
}
