{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.nautilus
    pkgs.ffmpeg-headless
    pkgs.ffmpegthumbnailer
  ];
  environment.pathsToLink = [ "/share/thumbnailers" ];
}
