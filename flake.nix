{
  description = "A collection of flake templates";

  outputs = { self }: {
    templates = {
      rails = {
        path = ./rails;
        description =
          "A shell for Rails projects with Postgres, Node, Yarn, etc.";
      };

      ruby-temp = {
        path = ./ruby-temp;
        description =
          "A shell with ruby whose gems are installed to a temporary directory.";
      };
    };

    defaultTemplate = self.templates.ruby-temp;
  };
}
