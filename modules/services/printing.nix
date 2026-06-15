{ ... }: {
  # Disabled by default — set enable = true to re-enable.
  # nssmdns4 is pre-configured so .local hostnames resolve when printing is active.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true; # resolves printer.local hostnames when avahi is enabled
  };
}
