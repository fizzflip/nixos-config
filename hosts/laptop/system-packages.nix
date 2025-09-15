{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs.mpv

    pkgs.localsend
    pkgs.ffmpeg-full

    pkgs.curl
    pkgs.aria2

    pkgs.ncdu
    pkgs.dust
    pkgs.yazi

    pkgs.bat
    pkgs.ripgrep
  ];
}
