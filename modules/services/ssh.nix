{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.ssh;
in
{
  options.my.services.ssh = {
    enable = lib.mkEnableOption "OpenSSH daemon and inter-machine SSH client configuration";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = lib.mkDefault true;
        KbdInteractiveAuthentication = false;
      };
    };

    # System-wide SSH client configuration for seamless cross-machine communication
    programs.ssh.extraConfig = ''
      Host machine machine.local
        HostName machine.local
        User ${config.my.user.name}
        IdentityFile /home/${config.my.user.name}/.ssh/id_ed25519
        StrictHostKeyChecking accept-new

      Host laptop laptop.local
        HostName laptop.local
        User ${config.my.user.name}
        IdentityFile /home/${config.my.user.name}/.ssh/id_ed25519
        StrictHostKeyChecking accept-new
    '';
  };
}
