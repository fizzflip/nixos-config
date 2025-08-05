{
  inputs,
  config,
  pkgs,
  ...
}:

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

    packages = [
      # Monitoring
      pkgs.btop
      pkgs.htop
      pkgs.fastfetch

      # Browsers
      # pkgs.librewolf
      pkgs.tor-browser
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
      pkgs.bottles
      pkgs.mangohud
      pkgs.gamemode
      pkgs.steam-run
      pkgs.prismlauncher

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
      pkgs.vscodium-fhs
      pkgs.jetbrains.idea-ultimate
      pkgs.jetbrains.pycharm-professional
      pkgs.nodejs_24

      # Archive Tools
      pkgs.p7zip-rar

      # Podman
      pkgs.dive
      pkgs.podman-tui
      pkgs.docker-compose
      pkgs.podman-compose

      # Ollama
      pkgs.ollama
      pkgs.oterm
      pkgs.gollama

      pkgs.android-tools
      pkgs.qbittorrent-enhanced

      pkgs.nixd
      pkgs.nixfmt-rfc-style

      pkgs.rawtherapee
      pkgs.gimp3-with-plugins
    ];
  };
}
