{ config, lib, pkgs, ... }:
lib.mkIf (!config.my.packages.minimal) {
  environment.systemPackages = [
    # Development
    pkgs.uv
    pkgs.gh
    pkgs.git
    pkgs.gcc
    pkgs.bun
    pkgs.yarn
    pkgs.pnpm
    pkgs.devenv
    pkgs.libgcc
    pkgs.nodejs
    pkgs.python3
    pkgs.zed-editor
    pkgs.antigravity-ide-fhs
    pkgs.jetbrains.idea
    pkgs.jetbrains.pycharm

    # Typst
    pkgs.typst
    pkgs.typstyle
    pkgs.typst-live
  ];
}
