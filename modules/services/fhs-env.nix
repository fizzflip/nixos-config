{ pkgs, ... }: {
  programs.nix-ld = {
    enable = true;
    libraries = (pkgs.steam-run.args.multiPkgs pkgs) ++ [
      pkgs.glib
      pkgs.nss
      pkgs.nspr
      pkgs.dbus
      pkgs.atk
      pkgs.at-spi2-atk
      pkgs.at-spi2-core
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
      pkgs.stdenv.cc.cc.lib
    ];
  };
  environment.systemPackages = [ pkgs.steam-run ];
}
