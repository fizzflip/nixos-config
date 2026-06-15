{ pkgs, ... }: {
  programs.nix-ld = {
    enable = true;
    libraries = [
      pkgs.glib
      pkgs.glibc
      pkgs.nss
      pkgs.nspr
      pkgs.dbus
      pkgs.atk
      pkgs.at-spi2-atk
      pkgs.at-spi2-core
      pkgs.libdrm
      pkgs.expat
      pkgs.libxkbcommon
      pkgs.pango
      pkgs.cairo
      pkgs.alsa-lib
      pkgs.libx11
      pkgs.libxcomposite
      pkgs.libxdamage
      pkgs.libxext
      pkgs.libxfixes
      pkgs.libxrandr
      pkgs.libxcb
      pkgs.libgbm
      pkgs.libGL
      pkgs.stdenv.cc.cc.lib
    ];
  };
  environment.systemPackages = [ pkgs.steam-run ];
}
