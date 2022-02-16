{
  description = "project-name";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          name = "project-name";

          buildInputs = with pkgs; [
            gcc
            gnumake
            libiconv
            libxml2
            libxslt
            nodejs-16_x
            openssl
            overmind
            pkgconfig
            postgresql
            readline
            ruby
            (yarn.override { nodejs = nodejs-16_x; })
            zlib
          ];
          shellHook = ''
            bundler_version=2.3.6
            gem_home="$PWD/.nix-gems"

            mkdir -p "$gem_home"
            echo "Using custom folder for gems... $gem_home"

            export GEM_HOME=$gem_home
            export GEM_PATH=$GEM_HOME
            export PATH=$GEM_HOME/bin:$PATH

            if [[ $(gem list --installed --version "$bundler_version" bundler) == "false" ]]; then
              gem install bundler --no-document --version "$bundler_version"
            fi
            bundle config --local build.nokogiri --use-system-libraries
            bundle config --local path vendor/cache
          '';
        };
      });
}
