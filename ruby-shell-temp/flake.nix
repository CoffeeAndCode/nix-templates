{
  description = "Ruby project shell with temporary gems";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            gcc
            gnumake
            libiconv
            libxml2
            libxslt
            nodejs
            openssl
            pkgconfig
            postgresql
            readline
            ruby
            yarn
            zlib
          ];

          shellHook = ''
            gem_home=$(mktemp -d)
            gemrc_file="$gem_home/.gemrc"
            echo "Using temporary folder for gems... $gem_home"

            touch $gemrc_file
            echo "gem: --no-document" > $gemrc_file

            export GEM_HOME=$gem_home
            export GEM_PATH=$GEM_HOME
            export GEMRC=$gemrc_file
            export PATH=$GEM_HOME/bin:$PATH
            export name="ruby-temp: $gem_home"
          '';
        };
      });
}
