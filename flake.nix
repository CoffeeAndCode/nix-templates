{
  description = "A collection of flake templates";

  outputs = { self }: {
    templates = {
      rails = {
        path = ./rails;
        description =
          "A bundix enhanced Rails project with Postgres, Node, Yarn, etc.";
      };

      rails-devenv = {
        path = ./rails-devenv;
        description =
          "Devenv + Rails with Postgres, Node, Yarn, etc.";
      };

      rails-shell = {
        path = ./rails-shell;
        description =
          "A shell for Rails projects with Postgres, Node, Yarn, etc.";
      };

      ruby = {
        path = ./ruby;
        description =
          "A flake that provides a `setup` app and a dev shell environment.";
      };

      ruby-shell-temp = {
        path = ./ruby-shell-temp;
        description =
          "A shell with ruby whose gems are installed to a temporary directory.";
      };
    };
  };
}
