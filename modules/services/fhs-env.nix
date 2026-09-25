{ pkgs, ... }: {
  programs.nix-ld = {
    enable = true;
    libraries = [
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
      pkgs.fuse3
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
      pkgs.openssl
      pkgs.curl
      pkgs.systemd
      pkgs.libglvnd
      pkgs.mesa
      pkgs.vulkan-loader
      pkgs.wayland
      pkgs.wayland-protocols
      pkgs.libdecor
      pkgs.libx11
      pkgs.libxcomposite
      pkgs.libxdamage
      pkgs.libxext
      pkgs.libxfixes
      pkgs.libxrandr
      pkgs.libxcb
      pkgs.libxcursor
      pkgs.libxi
      pkgs.libxrender
      pkgs.libxtst
    ];
  };

  environment.systemPackages = [
    pkgs.steam-run
  ];
}
