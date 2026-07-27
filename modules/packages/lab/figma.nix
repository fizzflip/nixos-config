{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.figma-agent
    pkgs.figma-linux
  ];
}
