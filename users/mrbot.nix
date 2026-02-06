{ inputs, pkgs, ... }:

{
  users.users.mrbot = {
    isNormalUser = true;
    description = "mrbot";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "kvm"
    ];
    shell = pkgs.zsh;

    hashedPassword = "$6$UanhywzWk0G21m4N$ePO/TL.pOesbz5rTFruqWa6yjk9X74zazexUocZaCKm3qXvE5NehIPrQxV.ElkWw41I2Rm7T0kfpGyZedtO1r1";

    packages = [
      # Monitoring
      pkgs.btop
      pkgs.htop
      pkgs.fastfetch

      # Browsers
      # pkgs.librewolf
      # pkgs.tor-browser
      pkgs.mullvad-browser
      pkgs.ungoogled-chromium
      inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default

      # Youtube
      pkgs.yt-dlp
      pkgs.freetube
      # pkgs.grayjay

      ## WiFi recon
      # pkgs.wifite2
      # pkgs.hashcat
      # pkgs.hcxdumptool
      # pkgs.hcxtools
      # pkgs.tshark
      # pkgs.reaverwps
      # pkgs.bully
      # pkgs.john
      # pkgs.cowpatty
      # pkgs.aircrack-ng
      # pkgs.iw
      # pkgs.nmap

      ## Game Tools
      pkgs.steam-run
      # pkgs.renpy
      # pkgs.mangohud
      # pkgs.gamemode
      # (pkgs.bottles.override { removeWarningPopup = true; })
      # (pkgs.prismlauncher.override {
      #   jdks = [
      #     pkgs.zulu
      #     pkgs.temurin-bin-21
      #   ];
      # })

      # Reading
      pkgs.foliate

      # Communication
      # pkgs.vesktop
      pkgs.anydesk
      pkgs.thunderbird

      # Note-taking
      pkgs.obsidian

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
      pkgs.figma-linux
      pkgs.vscodium-fhs
      pkgs.jetbrains.idea
      pkgs.jetbrains.pycharm
      # (pkgs.jetbrains.idea.override { forceWayland = true; })
      # (pkgs.jetbrains.pycharm.override { forceWayland = true; })

      # Archive Tools
      pkgs.p7zip-rar

      # Android
      pkgs.android-tools
      pkgs.android-studio

      # Torrent
      pkgs.qbittorrent-enhanced

      # Nix
      pkgs.nil
      pkgs.nixd
      pkgs.nixfmt
      pkgs.nix-tree

      # Image Editing
      # pkgs.gimp3-with-plugins

      # Emulation
      # pkgs.rpcs3
      pkgs.android-translation-layer
      pkgs.gradle_9
    ];
  };
}
