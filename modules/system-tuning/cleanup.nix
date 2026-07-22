{ ... }: {
  programs.nh.clean = {
    enable = true;
    dates = "weekly";
    extraArgs = "--keep-since 7d --keep 3";
  };
  documentation = {
    enable = true;
    nixos.enable = false;
    info.enable = false;
    doc.enable = false;
  };
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    SystemMaxFileSize=20M
    MaxRetentionSec=1month
  '';
  nix.settings.auto-optimise-store = true;
}
