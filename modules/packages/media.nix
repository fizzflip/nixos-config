{ pkgs, ... }: {
  environment.systemPackages = [
    # Video/Audio
    pkgs.mpv
    pkgs.ffmpeg-full
    pkgs.yt-dlp
    pkgs.freetube
    # grayjay

    # Reading/Note-taking
    pkgs.foliate
    pkgs.obsidian
    pkgs.mochi

    pkgs.libreoffice-fresh
  ];
}
