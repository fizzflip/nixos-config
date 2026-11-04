{ pkgs, ... }: {
  projectRootFile = "flake.nix";

  programs = {
    nixfmt = {
      enable = true;
      package = pkgs.nixfmt;
    };
    deadnix = {
      enable = true;
      no-lambda-arg = true;
      no-lambda-pattern-names = true;
    };
    statix = {
      enable = true;
    };
    shfmt = {
      enable = true;
      indent_size = 2;
    };
  };

  settings.formatter = {
    deadnix.priority = 1;
    statix.priority = 2;
    nixfmt.priority = 3;
  };

  settings.global.excludes = [
    "*.png"
    "*.jpg"
    "*.svg"
    "*.lock"
    "*.xml"
    ".omg/**"
  ];
}
