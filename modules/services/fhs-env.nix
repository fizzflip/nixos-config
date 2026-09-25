{ pkgs, ... }: {
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      fuse3
      glib
      nss
      nspr
      dbus
      atk
      at-spi2-atk
      at-spi2-core
      expat
      libxkbcommon
      pango
      cairo
      alsa-lib
      openssl
      curl
      systemd
      libglvnd
      mesa
      vulkan-loader
      wayland
      wayland-protocols
      libdecor
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxcb
      libxcursor
      libxi
      libxrender
      libxtst
    ];
  };

  environment.systemPackages = [
    pkgs.steam-run
  ];
}
