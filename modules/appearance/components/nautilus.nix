{ pkgs, ... }: {
  services.gnome.sushi.enable = true;
  environment.systemPackages = [
    pkgs.nautilus
    pkgs.ffmpeg-headless
    pkgs.ffmpegthumbnailer

    pkgs.gst_all_1.gstreamer
    pkgs.gst_all_1.gst-plugins-base
    pkgs.gst_all_1.gst-plugins-good
    pkgs.gst_all_1.gst-plugins-bad
    pkgs.gst_all_1.gst-plugins-ugly
  ];
  environment.pathsToLink = [ "/share/thumbnailers" ];
}
