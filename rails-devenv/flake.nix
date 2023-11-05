{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    systems.url = "github:nix-systems/default";

    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-ruby = {
      url = "github:bobvanderlinden/nixpkgs-ruby";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, devenv, nixpkgs, nixpkgs-ruby, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      # fix if using devenv newer than 0.6.3 till bug is fixed
      # https://github.com/cachix/devenv/issues/756
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

      devShells = forEachSystem
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
            };
            nodejs = pkgs.nodejs;
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  # https://devenv.sh/reference/options/
                  packages = [
                    pkgs.libyaml # needed for `psych` gem when running `rails new`

                    pkgs.nixpkgs-fmt
                    # pkgs.terraform
                    pkgs.vips
                    (pkgs.yarn.override { inherit nodejs; })
                  ];

                  languages.javascript = {
                    enable = true;
                    package = nodejs;
                  };

                  languages.ruby = {
                    enable = true;
                    version = "3.2";
                  };

                  process.implementation = "overmind";
                  processes = {
                    css.exec = "yarn build:css --watch";
                    web.exec = "unset PORT && bin/rails server";
                    worker.exec = "bundle exec sidekiq -t 10";
                  };

                  services.postgres.enable = true;
                  services.redis.enable = true;
                }
              ];
            };
          });
    };
}
