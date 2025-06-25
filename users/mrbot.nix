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

    packages = with pkgs; [
      # Monitoring
      bat
      btop
      htop
      fastfetch

      # Browsers
      librewolf
      tor-browser
      mullvad-browser
      ungoogled-chromium
      inputs.zen-browser.packages."${pkgs.system}".default

      # WiFi recon
      # wifite2
      # hashcat
      # hcxdumptool
      # hcxtools
      # tshark
      # reaverwps
      # bully
      # john
      # cowpatty
      # aircrack-ng
      # iw
      # nmap

      # Game Tools
      renpy
      bottles
      mangohud
      gamemode
      steam-run
      prismlauncher

      # Communication
      vesktop
      anydesk
      materialgram

      # Note-taking
      obsidian

      # Development
      uv
      gh
      git
      gcc
      zulu
      libgcc
      python3
      python312Packages.numpy
      python312Packages.pyopencl
      python312Packages.psutil
      intel-ocl

      vscodium-fhs
      jetbrains-toolbox

      # Archive Tools
      p7zip-rar

      # Podman
      dive
      podman-tui
      docker-compose
      podman-compose

      # Ollama
      ollama
      oterm
      # alpaca
      gollama

      android-tools
      qbittorrent-enhanced

      nixfmt-rfc-style

      nixd
      devenv
      direnv

      figma-linux

      # android-studio
      # androidsdk
      # android-tools
      # androidenv.androidPkgs.emulator
      # androidenv.androidPkgs.tools

      # android-udev-rules
      # libpng
      # ncurses5
      # zlib
    ];
  };
}
