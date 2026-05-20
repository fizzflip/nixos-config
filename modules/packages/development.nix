{ pkgs, ... }:
{
  environment.systemPackages = [
    # Development
    pkgs.uv
    pkgs.gh
    pkgs.git
    pkgs.gcc
    pkgs.bun
    pkgs.zulu
    pkgs.yarn
    pkgs.pnpm
    pkgs.devenv
    pkgs.libgcc
    pkgs.nodejs
    pkgs.python3
    pkgs.vscodium-fhs
    pkgs.antigravity-fhs
    pkgs.jetbrains.idea
    pkgs.jetbrains.pycharm

    # Typst
    pkgs.typst
    pkgs.typstyle
    pkgs.typst-live
  ];
}
