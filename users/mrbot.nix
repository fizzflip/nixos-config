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
      inputs.zen-browser.packages."${pkgs.system}".default

      # WiFi recon
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

      # Game Tools
      pkgs.renpy
      # pkgs.bottles
      # pkgs.mangohud
      # pkgs.gamemode
      pkgs.steam-run
      # pkgs.prismlauncher

      # Communication
      pkgs.vesktop
      pkgs.anydesk
      pkgs.materialgram

      # Note-taking
      pkgs.obsidian

      # Development
      pkgs.uv
      pkgs.gh
      pkgs.git
      pkgs.gcc
      pkgs.zulu
      pkgs.libgcc
      pkgs.python3
      pkgs.nodejs_24
      pkgs.vscodium-fhs
      pkgs.jetbrains.idea-ultimate
      pkgs.jetbrains.pycharm-professional

      # Archive Tools
      pkgs.p7zip-rar

      # Podman
      pkgs.dive
      pkgs.podman-tui
      pkgs.docker-compose
      pkgs.podman-compose

      # Ollama
      pkgs.oterm
      pkgs.ollama
      pkgs.gollama

      # Android
      pkgs.android-tools

      # Torrent
      pkgs.qbittorrent-enhanced

      # Nix formatting
      pkgs.nixd
      pkgs.nixfmt-rfc-style

      # Image Editing
      pkgs.gimp3-with-plugins

      pkgs.figma-linux
    ];
  };
}
